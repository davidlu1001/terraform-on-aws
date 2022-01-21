##############################################################################
# gateway/bastion
##############################################################################

locals {
  route53_record_prefix = "gateway"

  ec2_tags = {
    Name                    = "gateway-${local.name}"
    "Cost Center"           = "Platform"
    "Terraform"             = "true"
    "Environment"           = var.environment
    "ami_id"                = data.aws_ami.amazon_linux.id
    "vpc_domain"            = local.vpc_domain
    "route53_record_prefix" = local.route53_record_prefix
  }
}

# TODO - use KMS key to encrypt EBS volume
data "aws_kms_alias" "ebs" {
  name = "alias/aws/ebs"
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

resource "aws_instance" "ec2-gateway" {
  availability_zone = "${local.region}a"
  ami               = data.aws_ami.amazon_linux.id
  instance_type     = var.instance_type
  subnet_id         = element(flatten(module.vpc.public_subnets), 0)
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.bastion.id,
    aws_security_group.internal-icmp.id,
  ]
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.gateway.name
  key_name             = local.name

  user_data     = data.template_cloudinit_config.cloud_config.rendered
  ebs_optimized = true
  tags          = local.ec2_tags

  lifecycle {
    ignore_changes = [
      user_data,
      volume_tags,
    ]
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = var.root_volume_size
  }

  ebs_block_device {
    device_name           = "/dev/xvdb"
    volume_type           = "gp2"
    volume_size           = 1
    delete_on_termination = true
  }

  volume_tags = {
    "Cost Center" = "Platform"
  }
}

resource "aws_eip_association" "ec2-eip-association" {
  instance_id   = aws_instance.ec2-gateway.id
  allocation_id = aws_eip.gateway.id
}

# maps route53 record to eip
resource "aws_route53_record" "eip" {
  zone_id = var.zone_id
  name    = "${local.route53_record_prefix}-${element(split("-", aws_instance.ec2-gateway.id), 1)}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.gateway.public_ip]
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
  records         = [aws_instance.ec2-gateway.public_ip == "" ? aws_instance.ec2-gateway.private_ip : aws_instance.ec2-gateway.public_ip]
  allow_overwrite = true
}
