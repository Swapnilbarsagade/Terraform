output "alb_dns_name" {
  value = aws_lb.boxer_alb.dns_name
  description = "DNS name of the Application Load Balancer"
}

output "certificate_arn" {
  value = aws_acm_certificate.boxer_certificate.arn
}