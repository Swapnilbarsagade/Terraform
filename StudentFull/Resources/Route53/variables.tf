variable "domain_name" {
  description = "The domain name for the application"
}


variable "project_name" {}
variable "alb_dns_name" {}
variable "alb_zone_id" {}

variable "route53_zone_id" {
  description = "The Route 53 hosted zone ID"
  type        = string
}