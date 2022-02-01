resource "aws_autoscaling_lifecycle_hook" "graceful_shutdown_asg_hook" {
  count                  = var.enable_lifecycle_hook ? 1 : 0
  name                   = "asg_${var.name}_graceful_shutdown"
  autoscaling_group_name = aws_autoscaling_group.main.name
  default_result         = "CONTINUE"
  heartbeat_timeout      = var.lifecycle_hook_heartbeat_timeout
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
  role_arn               = aws_iam_role.autoscaling_role[0].arn
}

resource "aws_iam_role" "autoscaling_role" {
  count = var.enable_lifecycle_hook ? 1 : 0
  name  = "asg_${var.name}_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}
