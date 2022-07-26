variable "environment" {
  description = "Name of the current environment"
  type        = string
  nullable    = false
}

variable "subnets_list" {
  description = "List of subnets ids"
  type        = map(string)
}
variable "security_groups_list" {
  description = "List of security groups ids"
  type        = map(string)
}

variable "instances_list" {
  description = "List of instances ids"
  type        = map(string)
}

variable "acm_certificate_arn" {
  description = "value of the arn of the certificate"
  type        = string
}

variable "vpc_id" {
  description = "value of the vpc id"
  type        = string
}

variable "load_balancer" {
  description = "Load balancer"
  type = object({
    name                 = string
    internal             = bool
    load_balancer_type   = string
    security_groups_list = list(string)
    subnets_list         = list(string)
    lb_target_group = object({
      name        = string
      port        = string
      target_type = string
      vpc_id      = string
      protocol    = string
      health_check = object({
        enabled  = bool
        path     = string
        interval = number
        port     = number
        protocol = string
        matcher  = string
      })
    })
    lb_listener = list(object({
      name                = string
      port                = string
      protocol            = string
      default_action_type = string
      target_group_arn    = string
      ssl_policy          = string
      certificate_arn     = string
      redirect = list(object({
        status_code = string
        port        = number
        protocol    = string
      }))
    }))
    lb_target_group_attachment = object({
      target_id = string
      port      = number
    })
  })
}
