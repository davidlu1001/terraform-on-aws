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
  default = "172.21"
}

variable "region" {
  default = "ap-southeast-2"
}

variable "vpc_cidr" {
  default = "172.21.0.0/16"
}

variable "account_id" {
  default = "500955583076"
}

variable "environment" {
  default = "test"
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default     = {}
}

data "terraform_remote_state" "test-adroitcreations-org" {
  backend = "s3"

  config = {
    bucket = "ac-terraform-test"
    key    = "ap-southeast-2/test"
    region = "ap-southeast-2"
  }
}

data "terraform_remote_state" "dns-test" {
  backend = "s3"

  config = {
    bucket = "ac-terraform-test"
    key    = "dns/test"
    region = "ap-southeast-2"
  }
}

variable "ssh_pubkey_file" {
  description = "The public key for ssh keypair"
  default     = "~/.ssh/id_rsa_ac.pub"
  type        = string
}

data "terraform_remote_state" "app" {
  backend = "s3"

  config = {
    bucket = "app-terraform-test"
    key    = "ap-southeast-2/test"
    region = "ap-southeast-2"
  }
}

variable "instance_type" {
  description = "The EC2 instance type for gateway"
  default     = "t3a.small"
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
}
