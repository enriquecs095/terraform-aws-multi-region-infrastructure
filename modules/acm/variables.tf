variable "environment" {
  type        = string
  nullable    = false
  description = "Name of the current environment"
}

variable "dns_name" {
  type    = string
  description = "DNS chosen for the aws infrastructure environment"
}

variable "alb_dns_name" {
  type    = string
  description = "The DNS name of the application load balancer in us-east-1"
}

variable "alb_zone_id" {
  type    = string
  description = "The zone id of the application load balancer in us-east-1"
}
