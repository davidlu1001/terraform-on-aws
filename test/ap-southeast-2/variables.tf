locals {
  name        = "${var.namespace}-${var.environment}"
  region      = "ap-southeast-2"
  vpc_domain  = "test.adroitcreations.org"
  domain_name = "app.${local.vpc_domain}"

  cidr_blocks_public = {
    zone0 = "172.21.48.0/20"
    zone1 = "172.21.64.0/20"
    zone2 = "172.21.80.0/20"
  }

  cidr_blocks_private = {
    zone0 = "172.21.0.0/20"
    zone1 = "172.21.16.0/20"
    zone2 = "172.21.32.0/20"
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
  default     = "172.21"
  type        = string
}

variable "region" {
  description = "The Region"
  default     = "ap-southeast-2"
  type        = string
}

variable "vpc_cidr" {
  description = "The VPC CIDR"
  default     = "172.21.0.0/16"
  type        = string
}

variable "account_id" {
  description = "The AWS Account ID"
  default     = "500955583076"
  type        = string
}

variable "environment" {
  description = "The AWS Environment"
  default     = "test"
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

data "terraform_remote_state" "app" {
  backend = "s3"

  config = {
    bucket = "terraform-app-test"
    key    = "ap-southeast-2/test"
    region = "ap-southeast-2"
  }
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
  default     = "Z04806802JR0EAMPN7QPK"
  type        = string
}

variable "healthcheck_path" {
  description = "Path to a LB healthcheck endpoint"
  default     = "/"
  type        = string
}

variable "time_zone" {
  description = "Time zone for ASG instance"
  default     = "Pacific/Auckland"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  default     = ""
  type        = string
}

variable "route53_record_prefix" {
  description = "DNS prefix to be used when creating a custom route53 record for instances created by the autoscaling group."
  default     = ""
  type        = string
}

variable "cost_center" {
  description = "Cost Center to tag"
  default     = "Platform"
  type        = string
}

variable "vpc_domain" {
  description = "VPC domain for ASG instance"
  default     = "test.adroitcreations.org"
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
