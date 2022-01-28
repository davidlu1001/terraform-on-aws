resource "aws_cloudwatch_log_group" "ecs-log-group" {
  name              = "/ecs/${local.name}"
  retention_in_days = var.log_retention_in_days

  tags = local.tags
}

resource "aws_cloudwatch_log_stream" "ecs-log-stream" {
  name           = "ecs-log-stream-${local.name}"
  log_group_name = aws_cloudwatch_log_group.ecs-log-group.name
}
