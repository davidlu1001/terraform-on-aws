# Terraform on AWS

In this tutorial, using Terraform, we'll develop the high-level configuration files required to deploy a Django application to ECS.

Once configured, we'll run a single `make` command to set up the following AWS infrastructure:

- Init:
    - S3: for remote state
    - DynamoDB: for locking
    - KMS for encryption

- Networking (with existing [VPC](https://github.com/terraform-aws-modules/terraform-aws-vpc) module):
    - VPC
    - Public and private subnets
    - Routing tables
    - Internet Gateway
    - NAT Gateway

- DNS

- ACM with Route53 DNS validation (using existing [ACM](https://github.com/terraform-aws-modules/terraform-aws-acm) module)

- EC2 (Bastion/Gateway with local [EC2](https://github.com/davidlu1001/terraform-on-aws/tree/master/common/modules/ec2-instance) module)
    - Elastic IP
    - [cloud-init](https://github.com/canonical/cloud-init) (for cloud instance initialization)

- Key Pairs

- Security Groups
    - EC2
    - ASG
    - ALB
    - ECS
    - RDS

- Load Balancers
    - ALB
    - Target Groups
    - Listener Rules
    - Redict HTTP to HTTPS
    - Route53 Record for ALB

- IAM
    - Roles
    - Policies

- ECS
    - ECR
    - ECS Cluster
    - ECS Service
    - ECS Task Definition (with multiple containers and one-off migreate task)

- Auto Scaling Group with Launch Template (using local [ASG](https://github.com/davidlu1001/terraform-on-aws/tree/master/common/modules/asg) module)

- RDS (with existing [RDS](https://github.com/terraform-aws-modules/terraform-aws-rds) module)
    - Using [AWS Systems Manager Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html) with ECS task for DB credential

- Resource Groups (for Tags)

- CloudWatch Logs
    - Log Group
    - Log Stream

- Misc

    - Using `terraform.tfvars` for ***Test*** and ***Prod*** environments

    - Using [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform) to take care of Terraform configration / validation (e.g. `terraform fmt / tflint / tfsec` etc.)

    - Using Makefile for easier Terraform commands (e.g. `check / plan / apply / doc` etc.)

    - Add temp support for Terraform `exclude / include` features (re: [feature request](https://github.com/hashicorp/terraform/issues/2253))

    - Using [terraform-docs](https://github.com/terraform-docs/terraform-docs) to generate documentation for Terraform

# Ref Architecture

![reference architecture for deploying containerized microservices with ECS](https://github.com/aws-samples/ecs-refarch-cloudformation/raw/master/images/architecture-overview.png)
