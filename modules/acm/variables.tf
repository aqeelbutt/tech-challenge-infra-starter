variable "domain_name" {
  description = "The domain name to use for the ACM certificate"
  type        = string
}

variable "route53_zone_id" {
  description = "The Route 53 hosted zone ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "owner" {
  description = "Owner for tagging"
  type        = string
}