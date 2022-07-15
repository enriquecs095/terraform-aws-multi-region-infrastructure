locals {

  acm_certificate = {
    name              = "${var.acm_certificate.name}_${var.environment}"
    domain_name       = join(".", [var.environment, data.aws_route53_zone.dns.name])
    validation_method = var.acm_certificate.validation_method

  }
  route53_record = {
    ttl     = var.acm_certificate.ttl
    zone_id = data.aws_route53_zone.dns.zone_id
  }

  route53_alias = {
    name    = join(".", [var.environment, data.aws_route53_zone.dns.name])
    type    = var.acm_certificate.route53_record_type
    zone_id = data.aws_route53_zone.dns.zone_id
    alias = {
      name                   = var.alb_dns_name
      zone_id                = var.alb_zone_id
      evaluate_target_health = var.acm_certificate.evaluate_target_health
    }
  }
}
