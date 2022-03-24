# Terraform on AWS

In this tutorial, using Terraform, we'll develop the high-level configuration files required to deploy a Django application to ECS.

Once configured, we'll run a single `make` command to set up the following AWS infrastructure:

- Init:
    - S3: for storing remote state
    - DynamoDB: for state locking
    - KMS for encryption

- Networking (with existing [VPC](https://github.com/terraform-aws-modules/terraform-aws-vpc) module):
    - VPC
    - Public and private subnets
    - Routing tables
    - Internet Gateway
    - NAT Gateway

- DNS [Optional]

- ACM with Route53 DNS validation (using existing [ACM](https://github.com/terraform-aws-modules/terraform-aws-acm) module) [Optional]

- Add support for deployment without DNS zone ID and ACM certificate

- EC2 (Bastion/Gateway with local [EC2](https://github.com/davidlu1001/terraform-on-aws/tree/master/common/modules/ec2-instance) module)
    - Elastic IP
    - Route53 DNS record for bastion/gateway
    - Use [cloud-init](https://github.com/canonical/cloud-init) for EC2 instance initialization
    - Allow SSH access to the bastion/gateway with your [SSH Key Pair] uploaded to AWS
    - Allow bastion/gateway to access the DB instance under private subnet

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

# How to run
- Clone the repo to your local machine
- Run `make plan` to initialize and generate the Terraform execution plan for the whole infrastructure
- Run `make plan_include INCLUDE='ecr'` to ONLY deploy the AWS ECR repository and its policy
- Clone the repo [aws_devops_todo](https://github.com/davidlu1001/aws_devops_todo/tree/final) for Django demo application and run the following commands to build/test/publish the Docker image to AWS ECR repository:

```
export AWS_DEFAULT_PROFILE="[YOUR_AWS_PROFILE]"
export ACCOUNT_ID=[YOUR_AWS_ACCOUNT_ID]

make login
make test
make release
make publish
```
- For different environments (test / prod), modify the variables in the `terraform.tfvars` file accordingly
- Re-run `make plan` to generate the execution plan again for the AWS infrastructure
- Run `make apply` to deploy the AWS infrastructure

So far, the Terraform's state file is still stored ***Locally*** in the `.terraform` directory.

If you want to enable S3 bucket as Remote Backend, you can:
- Uncomment the `state.tf` file for each environment folder (test / prod)
- Run `make init` or `make plan` again to re-initialize the backend and migrate the state to remote S3 bucket

# Ref Architecture

![reference architecture for deploying containerized microservices with ECS](https://github.com/aws-samples/ecs-refarch-cloudformation/raw/master/images/architecture-overview.png)
