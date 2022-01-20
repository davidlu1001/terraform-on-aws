module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = local.vpc_cidr

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets  = values(local.cidr_blocks_public)
  private_subnets = values(local.cidr_blocks_private)

  # Single NAT Gateway
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = local.vpc_domain
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    "Terraform"   = "true"
    "Environment" = var.environment
    "Cost Center" = "Platform"
    "Name"        = local.name
    ResourceGroup = var.namespace
  }

  public_subnet_tags = {
    "Terraform"   = "true"
    "Environment" = var.environment
    "Cost Center" = "Platform"
    "Kind"        = "public"
  }

  private_subnet_tags = {
    "Terraform"   = "true"
    "Environment" = var.environment
    "Cost Center" = "Platform"
    "Kind"        = "private"
  }
}
