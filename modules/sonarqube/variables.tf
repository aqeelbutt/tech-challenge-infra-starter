variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "EKS cluster CA certificate"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "domain_name" {
  description = "Domain name for SonarQube ingress"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN"
  type        = string
}