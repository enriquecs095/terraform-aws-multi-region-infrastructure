locals {

  load_balancer = {
    name               = var.load_balancer.name
    internal           = var.load_balancer.internal
    load_balancer_type = var.load_balancer.load_balancer_type
    security_groups_list = flatten([
      for sg_lb in var.load_balancer.security_groups_list :
      var.security_groups_list["${sg_lb}_${var.environment}"]
    ])
    subnets_list = flatten([
      for subnet in var.load_balancer.subnets_list :
      var.subnets_list["${subnet}_${var.environment}"]
    ])
  }

  lb_target_group = {
    name        = var.load_balancer.lb_target_group.name
    port        = var.load_balancer.lb_target_group.port
    target_type = var.load_balancer.lb_target_group.target_type
    vpc_id      = var.vpc_id
    protocol    = var.load_balancer.lb_target_group.protocol
    health_check = {
      enabled  = var.load_balancer.lb_target_group.health_check.enabled
      path     = var.load_balancer.lb_target_group.health_check.path
      interval = var.load_balancer.lb_target_group.health_check.interval
      port     = var.load_balancer.lb_target_group.health_check.port
      protocol = var.load_balancer.lb_target_group.health_check.protocol
      matcher  = var.load_balancer.lb_target_group.health_check.matcher
    }
  }

  lb_listener_redirect = var.load_balancer.lb_listener_redirect

  lb_listener_forward = flatten([
    for listener in var.load_balancer.lb_listener_forward : [{
      name : listener.name
      port : listener.port,
      protocol : listener.protocol,
      default_action_type : listener.default_action_type,
      ssl_policy : listener.ssl_policy,
      certificate_arn : var.acm_certificate_arn,
      target_group_arn : listener.target_group_arn
    }]

  ])

  lb_target_group_attachment = {
    target_id = var.instances_list["${var.load_balancer.lb_target_group_attachment.target_id}_${var.environment}"]
    port      = var.load_balancer.lb_target_group_attachment.port
  }

}
