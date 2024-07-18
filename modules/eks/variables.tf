variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets for EKS"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnets for EKS"
  type        = list(string)
}

variable "secondary_cidr" {
  description = "Secondary CIDR block for EKS"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "instance_type" {
  description = "Instance type for the EKS node group"
  type        = string
}

variable "key_name" {
  description = "Key pair name to use for EKS node group"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "The domain name for the ACM certificate"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}
