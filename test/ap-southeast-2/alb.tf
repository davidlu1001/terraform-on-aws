resource "random_string" "lb_id" {
  length  = 3
  special = false
}

# Load Balancer
resource "aws_lb" "alb" {
  # Ensure load balancer name is unique
  name               = "alb-${local.name}-${random_string.lb_id.result}"
  load_balancer_type = "application"
  internal           = false
  subnets            = module.vpc.public_subnets
  #subnets         = flatten([module.vpc.public_subnets])
  security_groups = [aws_security_group.alb.id]

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}

# Target group
resource "aws_alb_target_group" "target-group" {
  name     = "tg-${local.name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = var.healthcheck_path
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200-299"
  }

  lifecycle {
    ignore_changes = [
      health_check["healthy_threshold"],
      health_check["unhealthy_threshold"],
      health_check["timeout"],
      health_check["interval"],
      health_check["path"],
    ]
    create_before_destroy = true
  }

  tags = local.tags
}

# HTTPS Listener (redirects traffic from the load balancer to the target group)
resource "aws_alb_listener" "alb-https-listener" {
  load_balancer_arn = aws_lb.alb.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = module.acm_lb.acm_certificate_arn
  depends_on        = [aws_alb_target_group.target-group]

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target-group.arn
  }

  tags = local.tags
}

# HTTP Listener - redirect action (http to https) "HTTPS://#{host}:443/#{path}?#{query}"
resource "aws_alb_listener" "alb-http-listener" {
  load_balancer_arn = aws_lb.alb.id
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.target-group]

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = local.tags
}
