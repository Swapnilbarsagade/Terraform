output "instance_domain_name" {
  value = aws_route53_record.boxer_dns_record.name
}
