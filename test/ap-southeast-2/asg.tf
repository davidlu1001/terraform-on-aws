locals {
  image_id = data.aws_ami.aws_optimized_ecs.id

  ecs_cluster_name_tag = (var.ecs_cluster_name == "" ? [] : [{
    key                 = "ecs_cluster_name"
    value               = var.ecs_cluster_name
    propagate_at_launch = true
  }])

  asg_tags = concat(local.ecs_cluster_name_tag, [local.required_tags],
    [
      {
        key                 = "Name"
        value               = "asg-${local.name}"
        propagate_at_launch = true
      },
      {
        key                 = "Environment"
        value               = var.environment
        propagate_at_launch = true
      },
      {
        key                 = "Cost Center"
        value               = var.cost_center
        propagate_at_launch = true
      },
      {
        key                 = "vpc_domain"
        value               = var.vpc_domain
        propagate_at_launch = true
      },
      {
        key                 = "route53_record_prefix"
        value               = local.name
        propagate_at_launch = true
      },
      {
        key                 = "zone_id"
        value               = var.zone_id
        propagate_at_launch = true
      },
      {
        key                 = "ami_id"
        value               = local.image_id
        propagate_at_launch = true
      },
  ])

  user_data = <<-EOT
  #!/bin/bash
  echo "Hello Terraform!"
  EOT
}

data "template_file" "cloud_config_asg" {
  template = file("files/cloud-config.yml.tpl")

  vars = {
    name   = "asg_${local.name}"
    prefix = local.name
    domain = var.vpc_domain
  }
}

data "template_cloudinit_config" "cloud_config_asg" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_config_asg.rendered
  }
}

resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = local.name

  # Sometimes good sleep is required to have some IAM resources created before they can be used
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "aws_iam_instance_profile" "ssm" {
  name = "asg_instance_profile_${local.name}"
  role = aws_iam_role.ssm.name
  tags = local.required_tags
}

resource "aws_iam_role" "ssm" {
  name = "asg_iam_role_${local.name}"
  tags = local.required_tags

  assume_role_policy = <<-EOT
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOT
}

# ASG + Launch template
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  # Autoscaling group
  name            = "asg-${local.name}"
  use_name_prefix = false
  instance_name   = "asg-instance-${local.name}"

  min_size                  = 0
  max_size                  = 0
  desired_capacity          = 0
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets
  service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn

  initial_lifecycle_hooks = [
    {
      name                 = "StartupLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 60
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                 = "TerminationLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 180
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template
  lt_name                = "lt-${local.name}"
  description            = "launch template"
  update_default_version = true

  use_lt    = true
  create_lt = true

  image_id      = local.image_id
  instance_type = var.instance_type
  #user_data_base64  = base64encode(local.user_data)
  user_data = base64encode(data.template_cloudinit_config.cloud_config.rendered)

  ebs_optimized     = true
  enable_monitoring = true

  iam_instance_profile_arn = aws_iam_instance_profile.ssm.arn
  # # Security group is set on the ENIs below
  # security_groups          = [module.asg_sg.security_group_id]

  target_group_arns = [aws_alb_target_group.target-group.arn]

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
    }
  ]

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [aws_security_group.ecs.id]
    }
  ]

  placement = {
    availability_zone = "${local.region}b"
  }

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = { WhatAmI = "Instance" }
    },
    {
      resource_type = "volume"
      tags          = merge({ WhatAmI = "Volume" }, local.required_tags)
    }
  ]

  tags = local.asg_tags

  # Autoscaling Schedule
  schedules = {
    night = {
      min_size         = 0
      max_size         = 0
      desired_capacity = 0
      recurrence       = "0 18 * * 1-5" # Mon-Fri in the evening
      time_zone        = var.time_zone
    }

    morning = {
      min_size         = 0
      max_size         = 1
      desired_capacity = 1
      recurrence       = "0 7 * * 1-5" # Mon-Fri in the morning
      time_zone        = var.time_zone
    }
  }

  # Target scaling policy schedule based on average CPU load
  scaling_policies = {
    avg-cpu-policy = {
      policy_type = "TargetTrackingScaling"
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
          resource_label         = local.name
        }
        target_value = 80.0
      }
    }
  }
}
