output "acm_master_arn" {
  description = "The arn of the acm certificate in us-east-1"
  value       = aws_acm_certificate.jenkins-lb-https.arn
}

