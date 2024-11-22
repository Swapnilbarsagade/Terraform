variable "domain_name" {
  description = "The domain name for the application"
}

variable "route53_zone_id" {
  description = "The ID of the Route53 hosted zone for DNS records"
  type        = string
}



variable "project_name" {}
variable "alb_dns_name" {}
variable "alb_zone_id" {}
