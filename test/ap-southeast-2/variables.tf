locals {
  name            = "${var.namespace}-${var.environment}"
  region          = "ap-southeast-2"
  vpc_root_domain = "test.adroitcreations.org"
  vpc_domain      = "app.${local.vpc_root_domain}"

  vpc_cidr = "172.21.0.0/16"

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

variable "account_id" {
  default = "500955583076"
}

variable "environment" {
  default = "test"
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
