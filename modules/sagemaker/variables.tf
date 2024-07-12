variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
}