output "instance_id" {
  value = aws_instance.main.id
}

output "instance_public_dns" {
  value = aws_instance.main.public_dns
}

output "instance_public_ip" {
  value = aws_instance.main.public_ip
}

output "instance_private_dns" {
  value = aws_instance.main.private_dns
}

output "instance_private_ip" {
  value = aws_instance.main.private_ip
}

output "instance_security_groups" {
  value = [aws_instance.main.vpc_security_group_ids]
}

