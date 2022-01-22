output "config" {
  value = {
    bucket         = aws_s3_bucket.s3_bucket.bucket
    dynamodb_table = aws_dynamodb_table.dynamodb_table.name
  }
}

output "tags" {
  value = local.tags
}

output "gateway" {
  value = {
    dns_record = aws_route53_record.gateway.fqdn
    public_ip  = module.ec2_gateway.instance_public_ip
  }
}

output "alb_public_dns_name" {
  description = "Public DNS names of the load balancer"
  value = {
    route53_record = aws_route53_record.alb.name
    alb_dns_name   = aws_lb.alb.dns_name
  }
}
