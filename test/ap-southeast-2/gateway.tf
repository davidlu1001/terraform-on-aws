##############################################################################
# gateway/bastion
##############################################################################

locals {
  route53_record_prefix = "gateway"
}

data "template_file" "cloud_config" {
  template = file("files/cloud-config.yml.tpl")

  vars = {
    prefix = local.route53_record_prefix
    domain = local.vpc_domain
  }
}

data "template_cloudinit_config" "cloud_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_config.rendered
  }
}

resource "aws_eip" "gateway" {
  vpc = true
}

module "ec2_gateway" {
  source = "../../common/modules/ec2-instance"

  name                        = "gateway-${local.name}"
  cost_center                 = "Platform"
  key_name                    = local.name
  environment                 = var.environment
  image_id                    = data.aws_ami.amazon_linux.id
  instance_ebs_optimized      = true
  associate_public_ip_address = true
  iam_instance_profile_arn    = aws_iam_instance_profile.gateway.name
  subnet_id                   = element(flatten(module.vpc.public_subnets), 0)

  security_groups = [
    aws_security_group.ssh.id,
    aws_security_group.bastion.id,
    aws_security_group.internal-icmp.id,
  ]

  region            = local.region
  availability_zone = "${local.region}a"

  instance_type             = var.instance_type
  root_volume_size          = var.root_volume_size
  vpc_domain                = local.vpc_domain
  route53_record_prefix     = local.route53_record_prefix
  zone_id                   = var.zone_id
  ebs_delete_on_termination = true
  eip_allocation_id         = aws_eip.gateway.id
}

resource "aws_iam_role" "gateway" {
  name               = "gateway-role-${local.name}"
  assume_role_policy = file("policies/ec2-assume-role.json")
}

resource "aws_iam_role_policy" "gateway" {
  name   = "gateway-policy-${local.name}"
  role   = aws_iam_role.gateway.id
  policy = file("policies/ec2-gateway-instance-profile.json")
}
resource "aws_iam_instance_profile" "gateway" {
  name = "gateway-profile-${local.name}"
  role = aws_iam_role.gateway.name
}

resource "aws_route53_record" "gateway" {
  zone_id         = var.zone_id
  name            = "gateway"
  type            = "A"
  ttl             = "300"
  records         = [aws_eip.gateway.public_ip]
  allow_overwrite = true
}
