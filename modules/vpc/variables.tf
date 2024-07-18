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
  description = "Name of the project"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "jumpbox_ami" {
  description = "AMI ID for the jumpbox"
  type        = string
}

variable "jumpbox_instance_type" {
  description = "Instance type for the jumpbox"
  type        = string
}

variable "key_name" {
  description = "Key pair name to use for instances"
  type        = string
}
