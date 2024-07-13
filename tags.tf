variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
}

locals {
  common_tags = merge(
    var.tags,
    {
      "Name"        = var.domain_name
      "Environment" = var.domain_name
      "Terraform"   = "true"
    }
  )
}