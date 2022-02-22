locals {
  name        = "${var.namespace}-${var.environment}"
  region      = var.region
  vpc_cidr    = "${var.subnet_octets}.0.0/16"
  vpc_domain  = "${var.environment}.${var.root_domain}"
  domain_name = "${var.namespace}.${local.vpc_domain}"

  cidr_blocks_public = {
    zone0 = "${var.subnet_octets}.48.0/20"
    zone1 = "${var.subnet_octets}.64.0/20"
    zone2 = "${var.subnet_octets}.80.0/20"
  }

  cidr_blocks_private = {
    zone0 = "${var.subnet_octets}.0.0/20"
    zone1 = "${var.subnet_octets}.16.0/20"
    zone2 = "${var.subnet_octets}.32.0/20"
  }

  required_tags = {
    "Terraform"   = "true"
    "Environment" = var.environment
    "Cost Center" = "Platform"
    ResourceGroup = var.namespace
  }

  tags = merge(var.resource_tags, local.required_tags)
}

variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  default     = "app"
  type        = string
}

variable "force_destroy_state" {
  description = "Force destroy the s3 bucket containing state files?"
  default     = true
  type        = bool
}

variable "subnet_octets" {
  description = "The CIDR prefix for VPC subnet"
  type        = string
}

variable "region" {
  description = "The Region"
  default     = "ap-southeast-2"
  type        = string
}

variable "account_id" {
  description = "The AWS Account ID"
  type        = string
}

variable "environment" {
  description = "The AWS Environment"
  type        = string
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default     = {}
}

variable "ssh_pubkey_file" {
  description = "The public key for ssh keypair"
  default     = "~/.ssh/id_rsa_ac.pub"
  type        = string
}


variable "instance_type" {
  description = "The EC2 instance type for gateway/ASG"
  default     = "t3a.micro"
  type        = string
}

variable "root_volume_size" {
  description = "The root volume size for EC2 instance"
  default     = 50
  type        = number
}

variable "zone_id" {
  description = "The route53 zone id for vpc_root_domain"
  type        = string
}

variable "healthcheck_path" {
  description = "Path to a LB healthcheck endpoint"
  default     = "/"
  type        = string
}

variable "cost_center" {
  description = "Cost Center to tag"
  default     = "Platform"
  type        = string
}

variable "root_domain" {
  description = "Root domain for VPC"
  default     = "adroitcreations.org"
  type        = string
}

variable "ecs_task_count" {
  description = "Number of instances of the task definition to place and keep running. Defaults to 0."
  default     = 1
  type        = number
}

variable "ecr_repo_name" {
  description = "ECR repositry name"
  default     = "aws-learn-devops/todobackend"
  type        = string
}

# ECR lifecycle policy
variable "ecr_image_count_tagged" {
  description = "Number of tagged images to keep in ECR"
  default     = 3
  type        = number
}

variable "ecr_image_days_untagged" {
  description = "Number of days to keep untagged images in ECR"
  default     = 1
  type        = number
}

variable "rds_db_name" {
  description = "DB Name for RDS"
  default     = "todobackend"
  type        = string
}

variable "rds_username" {
  description = "Username for RDS"
  default     = "todobackend"
  type        = string
}

# DB instance_type
variable "db_instance_type" {
  description = "DB Instance Type"
  default     = "db.t3.micro"
  type        = string
}

# DB multi_az
variable "multi_az" {
  description = "DB Multi AZ"
  default     = false
  type        = bool
}

# DB storage encrypted
variable "db_storage_encrypted" {
  description = "DB Storage Encrypted"
  default     = false
  type        = bool
}

# DB allocated_storage
variable "db_allocated_storage" {
  description = "DB Min Allocated Storage Size"
  default     = 20
  type        = number
}

# DB max_allocated_storage
variable "db_max_allocated_storage" {
  description = "DB Max Allocated Storage Size"
  default     = 100
  type        = number
}

# DB backup_retention_period
variable "backup_retention_period" {
  description = "DB Backup Retention Period"
  default     = 0
  type        = number
}

# DB skip_final_snapshot
variable "skip_final_snapshot" {
  description = "DB Skip Final Snapshot"
  default     = true
  type        = bool
}

# DB deletion_protection
variable "deletion_protection" {
  description = "DB Deletion Protection"
  default     = false
  type        = bool
}

# DB performance_insights_enabled
variable "performance_insights_enabled" {
  description = "DB Performance Insights Enabled"
  default     = false
  type        = bool
}

# DB performance_insights_retention_period
variable "performance_insights_retention_period" {
  description = "DB Performance Insights Retention Period"
  default     = 0
  type        = number
}

# CloudWatch Log retention_in_days
variable "log_retention_in_days" {
  description = "Log Retention In Days"
  default     = 1
  type        = number
}
