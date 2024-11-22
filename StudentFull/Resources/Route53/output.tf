output "hosted_zone_id" {
  description = "The ID of the hosted zone"
  value       = aws_route53_zone.main.zone_id
}



output "certificate_arn" {
  value = aws_acm_certificate.ssl_cert.arn
}

