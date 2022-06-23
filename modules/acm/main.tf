#ACM CONFIGURATION
#Get already, publicly configured Hosted Zone on Route53 - MUST EXIST
data "aws_route53_zone" "dns" {
  provider = aws.region-master
  name     = var.dns_name
}

#Creates ACM certificate and requests validation via DNS(Route53)
resource "aws_acm_certificate" "jenkins-lb-https" {
  provider          = aws.region-master
  domain_name       = join(".", [var.environment, data.aws_route53_zone.dns.name])
  validation_method = "DNS"
  tags = {
    Name = join("_", ["Jenkins-ACM", var.environment])
  }
}

#Validate ACM issued certificate via Route53
resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.region-master
  certificate_arn         = aws_acm_certificate.jenkins-lb-https.arn
  for_each                = aws_route53_record.cert-validation
  validation_record_fqdns = [aws_route53_record.cert-validation[each.key].fqdn]
}

#Create record in hosted zone for ACM  Certificate Domain verification
resource "aws_route53_record" "cert-validation" {
  provider = aws.region-master
  for_each = {
    for val in aws_acm_certificate.jenkins-lb-https.domain_validation_options : val.domain_name => {
      name   = val.resource_record_name
      record = val.resource_record_value
      type   = val.resource_record_type
    }
  }
  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = data.aws_route53_zone.dns.zone_id
}


#Create Alias record towards ALB from Route53
resource "aws_route53_record" "jenkins" {
  provider = aws.region-master
  name     = join(".", [var.environment, data.aws_route53_zone.dns.name])
  type     = "A"
  zone_id  = data.aws_route53_zone.dns.zone_id
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
