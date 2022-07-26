variable "environment" {
  description = "Name of the current environment"
  type        = string
  nullable    = false
}

variable "alb_dns_name" {
  description = "The DNS name of the application load balancer in us-east-1"
  type        = string
}

variable "alb_zone_id" {
  description = "The zone id of the application load balancer in us-east-1"
  type        = string
}

variable "acm_certificate" {
  description = "Value of the acm certificate"
  type = object({
    name                   = string
    dns_name               = string
    validation_method      = string
    route53_record_type    = string
    ttl                    = number
    evaluate_target_health = bool
  })
}
