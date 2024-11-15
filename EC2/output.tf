output "instance_domain_name" {
  value = aws_route53_record.student_dns_record.name
}