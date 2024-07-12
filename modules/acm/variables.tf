variable "domain_name" {
  description = "Domain name for ACM certificate"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
}