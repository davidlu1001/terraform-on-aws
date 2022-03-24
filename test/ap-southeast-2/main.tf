# Use module s3backend
module "s3backend" {
  source = "git@github.com:davidlu1001/terraform-on-aws-s3-backend.git?ref=simple"

  namespace           = local.name
  force_destroy_state = var.force_destroy_state
  tags                = local.tags
}
