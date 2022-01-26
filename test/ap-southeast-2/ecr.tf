resource "aws_ecr_repository" "app" {
  name = var.ecr_repo_name
  tags = local.tags
}
