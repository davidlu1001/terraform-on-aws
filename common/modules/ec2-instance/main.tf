data "template_file" "cloud_config" {
  template = file("${path.module}/files/cloud-config.yml.tpl")

  vars = {
    prefix = var.route53_record_prefix
    domain = var.vpc_domain
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

locals {
  required_tags = {
    Name                    = var.name
    "Cost Center"           = var.cost_center
    "Terraform"             = "true"
    "Environment"           = var.environment
    "ami_id"                = var.image_id
    "vpc_domain"            = var.vpc_domain
    "route53_record_prefix" = var.route53_record_prefix
    "zone_id"               = var.zone_id
  }
}

resource "aws_instance" "main" {
  ami                  = var.image_id
  availability_zone    = var.availability_zone
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_instance_profile_arn
  key_name             = var.key_name
  private_ip           = var.private_ip

  vpc_security_group_ids = var.security_groups

  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = data.template_cloudinit_config.cloud_config.rendered
  ebs_optimized               = var.instance_ebs_optimized
  tags                        = merge(var.extra_tags, local.required_tags)

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
    device_name           = var.ebs_device_name
    volume_type           = var.ebs_volume_type
    volume_size           = var.ebs_volume_size
    delete_on_termination = var.ebs_delete_on_termination
  }

  volume_tags = {
    "Cost Center" = var.cost_center
  }
}

resource "aws_eip_association" "main" {
  #count         = var.eip_allocation_id != "" ? 1 : 0
  instance_id   = aws_instance.main.id
  allocation_id = var.eip_allocation_id
}

# fetch eip if necessary
data "aws_eip" "main" {
  #count = var.eip_allocation_id != "" ? 1 : 0
  id = var.eip_allocation_id
}

# maps route53 record to eip
resource "aws_route53_record" "main_eip" {
  #count   = var.eip_allocation_id != "" ? 1 : 0
  zone_id = var.zone_id
  name    = "${var.route53_record_prefix}-${element(split("-", aws_instance.main.id), 1)}"
  type    = "A"
  ttl     = "300"
  records = [data.aws_eip.main.public_ip]
}
