variable "name" {
  description = "The instance name"
}

variable "environment" {
  description = "Environment"
}

variable "image_id" {
  description = "AMI Image ID"
}

variable "availability_zone" {
  description = "AZ where the instance should be placed. Should match the same subnet AZ"
}

variable "subnet_id" {
  description = "subnet_id"
}

variable "private_ip" {
  default     = ""
  description = "The private IP address to associate to the instance, e.g. 10.0.1.0"
}

variable "key_name" {
  description = "SSH key name to use"
}

variable "iam_instance_profile_arn" {
  description = "Instance profile arn"
  default     = ""
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

variable "cost_center" {
  description = "Cost Center to tag"
  default     = "Platform"
}

variable "instance_type" {
  description = "The instance type to use, e.g t3a.small"
}

variable "instance_ebs_optimized" {
  description = "When set to true the instance will be launched with EBS optimized turned on"
  default     = true
}

variable "associate_public_ip_address" {
  default = false
}

variable "eip_allocation_id" {
  description = "Elastic IP ID to allocate to the instance."
  default     = ""
}

variable "route53_record_prefix" {
  description = "DNS prefix to be used when creating a custom route53 record for instances created by the autoscaling group. This should match whatever is defined in our ansible inventory, e.g: ecs-consumer"
  default     = ""
}

variable "zone_id" {
  description = "Hosted Zone id"
  default     = ""
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  default     = 50
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

variable "ebs_delete_on_termination" {
  default = true
}

variable "extra_tags" {
  description = "Extra tags assigned to the EC2 instance."
  default     = {}
}

variable "router53_allow_overwrite" {
  description = "Allows TF to overwrite any prior record, to become the source-of-truth."
  default     = true
}

variable "extra_cloud_config_type" {
  description = "Extra cloud config type"
  default     = "text/cloud-config"
}

variable "extra_cloud_config_content" {
  description = "Extra cloud config content"
  default     = ""
}
