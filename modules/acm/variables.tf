variable "domain_name" {
  description = "Domain name for ACM certificate"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
}

variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID"
  type        = string
}
