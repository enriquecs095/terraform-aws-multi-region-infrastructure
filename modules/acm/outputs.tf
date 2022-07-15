output "acm_certificate_arn" {
  description = "The arn of the acm certificate in us-east-1"
  value       = aws_acm_certificate.lb-https.arn
}

output "url" {
  description = "The url of the dns server"
  value       = aws_route53_record.jenkins.fqdn
}