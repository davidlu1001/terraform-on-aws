# Accepts all traffic from entire VPC range for routing
resource "aws_security_group" "nat" {
  name        = "nat"
  description = "Used for NAT Gateways (managed)"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${var.subnet_octets}.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags

  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "internal-icmp" {
  name        = "internal-icmp"
  description = "Useful internal ICMP (managed)"

  ingress {
    protocol    = "icmp"
    from_port   = 8
    to_port     = -1
    cidr_blocks = ["${var.subnet_octets}.0.0/16"]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Bastion and SSH gateway rules (managed)"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags

  vpc_id = module.vpc.vpc_id
}

# Accepts traffic on tcp:22 from bastion nodes for management
resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "SSH access from the gateway (managed)"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags

  vpc_id = module.vpc.vpc_id
}

# ALB Security Group (Traffic Internet -> ALB)
resource "aws_security_group" "alb" {
  name        = "load_balancer_security_group"
  description = "Controls access to the ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
