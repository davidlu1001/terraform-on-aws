resource "aws_ecr_repository" "app" {
  name = var.ecr_repo_name
  tags = local.tags
}

resource "aws_ecr_lifecycle_policy" "app-policy" {
  repository = aws_ecr_repository.app.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire untagged images older than X days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${var.ecr_image_days_untagged}
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Keep last X images (for any tag)",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": ${var.ecr_image_count_tagged}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
