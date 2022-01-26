variable "name" {
  description = "The autoscaling group name, e.g cdn (the term asg will be prefixed)"
}

variable "environment" {
  default = "prod"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "image_id" {
  description = "AMI Image ID"
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "load_balancers" {
  description = "A list of elastic load balancer names to add to the autoscaling group names."
  type        = list(string)
  default     = []
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  default     = ""
}

variable "target_group_arns" {
  description = "A list of aws_alb_target_group ARNs, for use with Application Load Balancing."
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "SSH key name to use"
}

variable "iam_instance_profile_arn" {
  description = "Instance profile arn"
}

variable "security_groups" {
  description = "List of security groups"
  type        = list(string)
}

variable "region" {
  description = "AWS Region"
}

variable "vpc_domain" {
}

variable "ansible_branch" {
  description = "Ansible default's branch"
  default     = "master"
}

variable "ansible_play" {
  description = "Ansible play path to run"
  default     = ""
}

variable "cost_center" {
  description = "Cost Center to tag"
  default     = "Platform"
}

variable "zone_id" {
  description = "The zone ID to tag ecs instances"
}

variable "instance_type" {
  description = "The instance type to use, e.g t2.small"
}

variable "instance_ebs_optimized" {
  description = "When set to true the instance will be launched with EBS optimized turned on"
  default     = true
}

variable "associate_public_ip_address" {
  default = false
}

variable "disable_api_termination" {
  description = "If `true`, enables EC2 Instance Termination Protection"
  default     = false
}

variable "route53_record_prefix" {
  description = "DNS prefix to be used when creating a custom route53 record for instances created by the autoscaling group. This should match whatever is defined in our ansible inventory, e.g: ecs-consumer"
}

variable "min_size" {
  description = "Minimum instance count"
  default     = 2
}

variable "max_size" {
  description = "Maxmimum instance count"
  default     = 2
}

variable "desired_capacity" {
  description = "Desired instance count"
  default     = 2
}

variable "asg_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  default     = 300
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  default     = 600
}

variable "asg_termination_policy" {
  type    = list(string)
  default = ["OldestLaunchTemplate", "OldestLaunchConfiguration", "AllocationStrategy", "OldestInstance", "Default"]
}

variable "suspended_processes" {
  type    = list(string)
  default = ["AZRebalance"]
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  default     = 30
}

variable "root_delete_on_termination" {
  default = true
}

variable "ebs_snapshot" {
  description = "snapshot ID to mount"
  default     = ""
}

variable "ebs_volume_size" {
  description = "ebs volume size in GB"
  default     = 1
}

variable "ebs_volume_type" {
  description = "ebs volume device type"
  default     = "gp2"
}

variable "ebs_device_name" {
  description = "ebs volume device name"
  default     = "/dev/xvdb"
}

variable "ebs_partition_type" {
  description = "ebs volume partition type"
  default     = "ext4"
}

variable "ebs_delete_on_termination" {
  default = true
}

variable "extra_cloud_config_type" {
  description = "Extra cloud config type"
  default     = "text/cloud-config"
}

variable "extra_cloud_config_content" {
  description = "Extra cloud config content"
  default     = ""
}

variable "lifecycle_hook_heartbeat_timeout" {
  default = 1800
}

variable "enable_lifecycle_hook" {
  description = "Should lifecycle hook be enabled?"
  default     = false
}

variable "tags" {
  description = "A list of tag blocks. Each element should have keys named key, value, and propagate_at_launch."
  type        = list(any)
  default     = []
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instances. Can be `stop` or `terminate`"
  default     = "terminate"
}

variable "credit_specification" {
  description = "Specifies the credit option for CPU usage of a T2 or T3 instance."

  default = {
    cpu_credits = "standard"
  }
}

variable "enable_monitoring" {
  description = "Enable/disable detailed monitoring"
  default     = true
}

variable "on_demand_base_capacity" {
  description = "defining the number of OnDemand instances that you want as a basis (our minimum of instances to be safe with your minimum traffic for example)."
  default     = 3
}

variable "instance_types_override" {
  type    = list(string)
  default = []
}

variable "protect_from_scale_in" {
  default = false
}

variable "spot_allocation_strategy" {
  description = "How to allocate capacity across the Spot pools. Valid values: lowest-price, capacity-optimized. "
  default     = "lowest-price"
}

variable "spot_instance_pools" {
  description = "Number of Spot pools per availability zone to allocate capacity. EC2 Auto Scaling selects the cheapest Spot pools and evenly allocates Spot capacity across the number of Spot pools that you specify"
  default     = 1
}

variable "on_demand_percentage_above_base_capacity" {
  description = "defining the percentage of OnDemand instances compared to Spot instances beyond the base capacity (0 : 0% Spot, 100% On-demand)."
  default     = 100
}

variable "spot_max_price" {
  description = "Max spot price based on instance type"

  default = {
    "c5.large"   = 0.051
    "c5.xlarge"  = 0.102
    "c5.2xlarge" = 0.204
    "i3.large"   = 0.102
    "i3.xlarge"  = 0.202
    "i3.2xlarge" = 0.406
    "r5.large"   = 0.076
    "m5.large"   = 0.058
  }
}

variable "max_instance_lifetime" {
  description = "The maximum amount of time, in seconds, that an instance can be in service, values must be either equal to 0 or between 604800 and 31536000 seconds."
  type        = number
  default     = 0
}
