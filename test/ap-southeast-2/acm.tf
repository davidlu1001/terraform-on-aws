module "acm_lb" {
  count   = length(var.zone_id) > 0 ? 1 : 0
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name = local.domain_name
  zone_id     = var.zone_id

  subject_alternative_names = [
    "*.${local.domain_name}",
  ]

  wait_for_validation = true

  tags = local.tags
}
