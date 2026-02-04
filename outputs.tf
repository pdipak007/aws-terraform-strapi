output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.strapi.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.strapi.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.strapi.public_dns
}

output "strapi_url" {
  description = "URL to access Strapi application"
  value       = "http://${aws_instance.strapi.public_ip}:1337"
}

output "strapi_admin_url" {
  description = "URL to access Strapi admin panel"
  value       = "http://${aws_instance.strapi.public_ip}:1337/admin"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.strapi.public_ip}"
}

output "elastic_ip" {
  description = "Elastic IP address (if enabled)"
  value       = var.use_elastic_ip ? aws_eip.strapi[0].public_ip : null
}
