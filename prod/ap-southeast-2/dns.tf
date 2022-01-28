resource "aws_route53_record" "alb" {
  zone_id         = var.zone_id
  name            = local.domain_name
  type            = "CNAME"
  ttl             = "300"
  records         = [aws_lb.alb.dns_name]
  allow_overwrite = true
}
