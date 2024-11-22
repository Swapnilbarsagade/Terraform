variable "domain_name" {
  description = "The domain name for the application"
}

variable "route53_zone_id" {
  description = "The Route53 Hosted Zone ID"
  type        = string
}


variable "project_name" {}
variable "alb_dns_name" {}
variable "alb_zone_id" {}
