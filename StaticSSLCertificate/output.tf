output "alb_dns_name" {
  value = aws_lb.boxer_alb.dns_name
  description = "DNS name of the Application Load Balancer"
}
