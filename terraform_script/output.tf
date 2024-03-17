output "bastion-host-ip" {
  description = "Public IP of the Setup-Server"
  value       = aws_instance.bastion.public_ip
}

output "webserver-ips" {
  description = "Private IP of the Setup-Server"
  value       = aws_instance.webserver[0].private_ip
}

output "lb-endpoint" {
  description = "DNS Name of ALB"
  value       = aws_lb.loadbalancer.dns_name
}
