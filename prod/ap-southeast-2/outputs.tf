output "config" {
  value = {
    bucket         = module.s3backend.s3_bucket
    dynamodb_table = module.s3backend.dynamodb_table
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

output "asg" {
  description = "Names / ARNs of the ASG / Launch Template"
  value = {
    asg_name                           = module.asg.name
    asg_arn                            = module.asg.asg_arn
    asg_launch_template_arn            = module.asg.asg_launch_template_arn
    asg_launch_template_latest_version = module.asg.asg_launch_template_latest_version
  }
}

output "db_info" {
  description = "DB endpoint/name info"
  value = {
    db_address = module.db.db_instance_address
    db_port    = module.db.db_instance_port
    db_name    = module.db.db_instance_name
  }
}

output "db_login" {
  description = "DB login info"
  value = {
    db_username = module.db.db_instance_username
    db_password = module.db.db_master_password
  }
  sensitive = true
}
