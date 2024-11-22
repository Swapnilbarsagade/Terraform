output "hosted_zone_id" {
  value = aws_route53_zone.main.zone_id
}


output "certificate_arn" {
  value = aws_acm_certificate.ssl_cert.arn
}


output "alb_zone_id" {
  value = aws_lb.app_lb.zone_id
}
