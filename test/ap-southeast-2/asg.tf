locals {
  image_id = data.aws_ami.aws_optimized_ecs.id
}

data "template_file" "asg-instance-profile" {
  template = file("../../common/policies/asg-ecs-policy.json.tpl")

  vars = {
    asg_name = module.asg.name
  }
}

resource "aws_iam_role" "asg-role" {
  name               = "asg-${local.name}"
  assume_role_policy = file("../../common/policies/ec2-assume-role.json")
}

resource "aws_iam_role_policy" "asg-role-policy" {
  name   = "asg-${local.name}"
  role   = aws_iam_role.asg-role.id
  policy = data.template_file.asg-instance-profile.rendered
}

resource "aws_iam_instance_profile" "asg-profile" {
  name = "asg-instance-profile-${local.name}"
  role = aws_iam_role.asg-role.name
}

data "template_file" "ecs_extra_cloudinit_content" {
  template = file("../../common/files/ecs-extra-cloud-config.sh.tpl")

  vars = {
    ASG_NAME           = "asg-${local.name}"
    AWS_DEFAULT_REGION = local.region
    ECS_CLUSTER        = "ecs-${local.name}"
  }
}

module "asg" {
  source = "../../common/modules/asg"

  name                     = local.name
  key_name                 = local.name
  environment              = var.environment
  vpc_id                   = module.vpc.vpc_id
  image_id                 = local.image_id
  instance_ebs_optimized   = true
  iam_instance_profile_arn = aws_iam_instance_profile.asg-profile.arn
  subnet_ids               = module.vpc.private_subnets
  security_groups          = [aws_security_group.ecs.id]

  on_demand_base_capacity                  = 0
  on_demand_percentage_above_base_capacity = 100

  region                           = local.region
  instance_type                    = var.instance_type
  protect_from_scale_in            = false
  min_size                         = 0
  max_size                         = 1
  desired_capacity                 = 1
  root_volume_size                 = var.root_volume_size
  asg_cooldown                     = 420
  vpc_domain                       = local.vpc_domain
  zone_id                          = var.zone_id
  route53_record_prefix            = local.name
  enable_lifecycle_hook            = false
  lifecycle_hook_heartbeat_timeout = 1800
  suspended_processes              = ["AZRebalance", "ReplaceUnhealthy"]
  ebs_delete_on_termination        = true
  ebs_volume_size                  = 1
  extra_cloud_config_type          = "text/x-shellscript"
  extra_cloud_config_content       = data.template_file.ecs_extra_cloudinit_content.rendered
  target_group_arns                = [aws_alb_target_group.target-group.arn]
}
