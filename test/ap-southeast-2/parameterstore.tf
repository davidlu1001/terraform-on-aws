data "aws_kms_alias" "ssm" {
  name = "alias/aws/ssm"
}

# Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role_policy.json
  path               = "/"
}

data "aws_iam_policy_document" "ecs_task_execution_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution.arn
}

# Use SSM for DB password

resource "random_password" "database_password" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "database_password_parameter" {
  name        = "/${var.environment}/${local.region}/${local.name}/databases_password"
  description = "${var.environment} environment database password for ${local.name}"
  type        = "SecureString"
  value       = random_password.database_password.result

  tags = local.tags
}

resource "aws_iam_role_policy" "password_policy" {
  name = "password-policy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ssm:GetParameters",
          "kms:Decrypt"
        ],
        "Effect": "Allow",
        "Resource": [
          "${aws_ssm_parameter.database_password_parameter.arn}",
          "${data.aws_kms_alias.ssm.arn}"
        ]
      }
    ]
  }
  EOF
}
