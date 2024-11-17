# Output for the Application Load Balancer (ALB) DNS name
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.student_alb.dns_name
}

# Output for the Public IP address of the EC2 instance
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

# Output for the Route 53 domain
output "route53_domain" {
  description = "DNS record created in Route 53"
  value       = aws_route53_record.student_dns_record.fqdn
}
