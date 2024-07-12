resource "aws_acm_certificate" "wildcard" {
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"
  tags              = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}