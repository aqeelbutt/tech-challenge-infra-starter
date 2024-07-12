variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "secondary_cidr" {
  description = "Secondary CIDR block for EKS"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
}