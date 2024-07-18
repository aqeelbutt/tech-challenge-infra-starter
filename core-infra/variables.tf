variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "secondary_cidr" {
  description = "Secondary CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "owner" {
  description = "Owner for tagging"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the ACM certificate"
  type        = string
}

variable "route53_zone_id" {
  description = "Route 53 Zone ID"
  type        = string
}

variable "jumpbox_ami" {
  description = "AMI for the jumpbox"
  type        = string
}

variable "jumpbox_instance_type" {
  description = "Instance type for the jumpbox"
  type        = string
}

variable "key_name" {
  description = "Key pair name for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EKS node group"
  type        = string
}