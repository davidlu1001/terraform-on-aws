# The cluster name, e.g cdn
output "name" {
  value = aws_autoscaling_group.main.name
}

output "asg_arn" {
  value = aws_autoscaling_group.main.arn
}

output "asg_id" {
  value = aws_autoscaling_group.main.id
}

output "asg_launch_template_id" {
  value = aws_launch_template.main.id
}

output "asg_launch_template_arn" {
  value = aws_launch_template.main.arn
}

output "asg_launch_template_default_version" {
  value = aws_launch_template.main.default_version
}

output "asg_launch_template_latest_version" {
  value = aws_launch_template.main.latest_version
}
