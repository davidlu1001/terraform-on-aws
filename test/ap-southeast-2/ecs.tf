resource "aws_iam_role" "ecs-service-role" {
  name               = "ecs-service-role-${local.name}"
  assume_role_policy = file("../../common/policies/ecs-assume-role.json")
}

resource "aws_iam_role_policy" "ecs-service-role-policy" {
  name   = "ecs-servicelrole-policy-${local.name}"
  policy = file("../../common/policies/ecs-service-role-policy.json")
  role   = aws_iam_role.ecs-service-role.id
}

resource "aws_ecs_cluster" "app" {
  name = "ecs-${local.name}"

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}

data "template_file" "app" {
  template = file("../../common/files/task-def-app.json.tpl")

  vars = {
    name         = local.name
    docker_image = aws_ecr_repository.app.repository_url
    image_tag    = "latest"
    region       = local.region
    rds_db_name  = var.rds_db_name
    rds_username = var.rds_username
    rds_password = aws_ssm_parameter.database_password_parameter.arn
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#attributes-reference
    rds_hostname = module.db.db_instance_address
  }

  depends_on = [
    module.db
  ]
}

resource "aws_ecs_task_definition" "app" {
  family                = local.name
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = data.template_file.app.rendered

  volume {
    name      = "public"
    host_path = "/data/public"
  }
}

resource "aws_ecs_service" "app" {
  name            = "ecs-service-${local.name}"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.app.arn
  iam_role        = aws_iam_role.ecs-service-role.arn
  desired_count   = var.ecs_task_count
  depends_on = [
    module.asg,
    aws_cloudwatch_log_group.ecs-log-group,
    aws_alb_listener.alb-https-listener,
    null_resource.migrate
  ]

  load_balancer {
    target_group_arn = aws_alb_target_group.target-group.arn
    container_name   = local.name
    container_port   = 8000
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [ap-southeast-2a, ap-southeast-2b, ap-southeast-2c]"
  }

  lifecycle {
    ignore_changes = [
      desired_count
    ]
    create_before_destroy = true
  }
}

# Onetime ECS task for db migrate

data "template_file" "migrate" {
  template = file("../../common/files/task-def-migrate.json.tpl")

  vars = {
    name         = local.name
    docker_image = aws_ecr_repository.app.repository_url
    image_tag    = "latest"
    region       = local.region
    rds_db_name  = var.rds_db_name
    rds_username = var.rds_username
    rds_password = aws_ssm_parameter.database_password_parameter.arn
    rds_hostname = module.db.db_instance_address
  }

  depends_on = [
    module.db
  ]
}

resource "aws_ecs_task_definition" "migrate" {
  family                = "${local.name}-migrate"
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = data.template_file.migrate.rendered
}

# null resource to trigger ECS task and sleep for 10 seconds
# to allow the task to be created
resource "null_resource" "migrate" {
  triggers = {
    task_definition = aws_ecs_task_definition.migrate.arn
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
set -e

sleep 10
aws ecs run-task \
  --region ${local.region} \
  --cluster ${aws_ecs_cluster.app.arn} \
  --task-definition ${aws_ecs_task_definition.migrate.arn} \
  --launch-type EC2 \
  --started-by "Terraform"
EOF
  }
}
