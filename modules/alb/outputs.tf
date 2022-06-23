output "alb_dns_name" {
  description = "The DNS name of the application load balancer in us-east-1"
  value       = aws_lb.application-lb.dns_name
}

output "alb_zone_id" {
  description = "The zone id of the application load balancer in us-east-1"
  value       = aws_lb.application-lb.zone_id
}

