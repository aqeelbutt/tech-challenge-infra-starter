variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
}

locals {
  common_tags = merge(
    var.tags,
    {
      "Environment" = "dev"
      "Terraform"   = "true"
    }
  )
}