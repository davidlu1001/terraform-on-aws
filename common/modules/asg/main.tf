locals {

  ansible_tags = [
    {
      key                 = "ANSIBLE_BRANCH"
      value               = var.ansible_branch
      propagate_at_launch = true
    },
    {
      key                 = "ANSIBLE_PLAY"
      value               = var.ansible_play
      propagate_at_launch = true
    }
  ]

  ecs_cluster_name_tag = (var.ecs_cluster_name == "" ? [] : [{
    key                 = "ecs_cluster_name"
    value               = var.ecs_cluster_name
    propagate_at_launch = true
  }])

  required_tags = concat(local.ansible_tags, local.ecs_cluster_name_tag, var.tags,
    [
      {
        key                 = "Name"
        value               = "asg-${var.name}"
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
        value               = var.route53_record_prefix
        propagate_at_launch = true
      },
      {
        key                 = "zone_id"
        value               = var.zone_id
        propagate_at_launch = true
      },
      {
        key                 = "ami_id"
        value               = var.image_id
        propagate_at_launch = true
      }
  ])
}

data "template_file" "cloud_config" {
  template = file("${path.module}/files/cloud-config.yml.tpl")
  vars = {
    name                         = var.name
    prefix                       = var.route53_record_prefix
    domain                       = var.vpc_domain
    ebs_device_name              = var.ebs_device_name
    ebs_partition_type           = var.ebs_partition_type
    asg_healthcheck_grace_period = var.health_check_grace_period
  }
}

data "template_cloudinit_config" "cloud_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_config.rendered
  }

  part {
    content_type = var.extra_cloud_config_type
    content      = var.extra_cloud_config_content
  }
}

resource "aws_launch_template" "main" {
  name_prefix = format("%s-", var.name)

  dynamic "credit_specification" {
    for_each = [var.credit_specification]
    content {
      cpu_credits = lookup(credit_specification.value, "cpu_credits", null)
    }
  }
  disable_api_termination              = var.disable_api_termination
  ebs_optimized                        = var.instance_ebs_optimized
  image_id                             = var.image_id
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_type                        = var.instance_type
  key_name                             = var.key_name
  user_data                            = base64encode(data.template_cloudinit_config.cloud_config.rendered)

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name          = var.name
      "Cost Center" = var.cost_center
      "Terraform"   = "true"
      "Environment" = var.environment
      "ami_id"      = var.image_id
      "vpc_domain"  = var.vpc_domain
    }
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "gp2"
      volume_size           = var.root_volume_size
      delete_on_termination = var.root_delete_on_termination
    }
  }

  block_device_mappings {
    device_name = var.ebs_device_name

    ebs {
      volume_type           = var.ebs_volume_type
      volume_size           = var.ebs_volume_size
      delete_on_termination = var.ebs_delete_on_termination
      snapshot_id           = var.ebs_snapshot
    }
  }

  iam_instance_profile {
    arn = var.iam_instance_profile_arn
  }

  monitoring {
    enabled = var.enable_monitoring
  }

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = var.security_groups
    delete_on_termination       = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [latest_version]
  }
}

resource "aws_autoscaling_group" "main" {
  name                = "asg-${var.name}"
  vpc_zone_identifier = var.subnet_ids
  load_balancers      = var.load_balancers
  target_group_arns   = var.target_group_arns

  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  termination_policies      = var.asg_termination_policy
  default_cooldown          = var.asg_cooldown
  health_check_grace_period = var.health_check_grace_period
  suspended_processes       = var.suspended_processes
  enabled_metrics           = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  wait_for_capacity_timeout = "15m"
  protect_from_scale_in     = var.protect_from_scale_in
  max_instance_lifetime     = var.max_instance_lifetime

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.on_demand_base_capacity
      on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity

      spot_max_price           = ""
      spot_allocation_strategy = var.spot_allocation_strategy
      spot_instance_pools      = var.spot_instance_pools
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.main.id
        version            = aws_launch_template.main.latest_version
      }

      dynamic "override" {
        for_each = concat([var.instance_type], var.instance_types_override)

        content {
          instance_type = override.value
        }
      }
    }
  }

  tags = local.required_tags

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      min_size,
      max_size,
      desired_capacity,
      default_cooldown,
      health_check_grace_period,
      suspended_processes,
    ]
  }
}
