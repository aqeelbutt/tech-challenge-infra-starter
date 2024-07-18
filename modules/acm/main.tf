locals {
  common_tags = {
    Project = var.project_name
    Owner   = var.owner
  }
}

resource "aws_acm_certificate" "wildcard" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Project = var.project_name
    Owner   = var.owner
    Name    = "wildcard-certificate"
  }
}

resource "aws_route53_record" "wildcard_validation" {
  for_each = {
    for dvo in aws_acm_certificate.wildcard.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "wildcard" {
  certificate_arn         = aws_acm_certificate.wildcard.arn
  validation_record_fqdns = [for record in aws_route53_record.wildcard_validation : record.fqdn]

  depends_on = [aws_route53_record.wildcard_validation]
}
