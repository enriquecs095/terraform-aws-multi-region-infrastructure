resource "aws_lb" "application-lb" {
  provider           = aws
  name               = "${local.load_balancer.name}-${var.environment}"
  internal           = local.load_balancer.internal
  load_balancer_type = local.load_balancer.load_balancer_type
  security_groups    = local.load_balancer.security_groups_list
  subnets            = local.load_balancer.subnets_list
  tags = {
    Name = "${local.load_balancer.name}-${var.environment}"
  }
}

resource "aws_lb_target_group" "app-lb-tg" {
  provider    = aws
  name        = "${local.lb_target_group.name}-${var.environment}"
  port        = local.lb_target_group.port
  target_type = local.lb_target_group.target_type
  vpc_id      = local.lb_target_group.vpc_id
  protocol    = local.lb_target_group.protocol
  health_check {
    enabled  = local.lb_target_group.health_check.enabled
    path     = local.lb_target_group.health_check.path
    interval = local.lb_target_group.health_check.interval
    port     = local.lb_target_group.health_check.port
    protocol = local.lb_target_group.health_check.protocol
    matcher  = local.lb_target_group.health_check.matcher
  }
  tags = {
    Name = "${local.lb_target_group.name}-${var.environment}"
  }

}

resource "aws_lb_listener" "lb-listener-http" {
  provider          = aws
  load_balancer_arn = aws_lb.application-lb.arn
  for_each = {
    for listener in local.lb_listener_redirect : listener.name => listener
  }
  port     = each.value.port
  protocol = each.value.protocol
  default_action {
    type = each.value.default_action_type
    redirect {
      status_code = each.value.redirect.status_code
      port        = each.value.redirect.port
      protocol    = each.value.redirect.protocol
    }
  }
  tags = {
    Name = "${each.value.name}_${var.environment}"
  }
}


resource "aws_lb_listener" "lb-listener-https" {
  provider          = aws
  load_balancer_arn = aws_lb.application-lb.arn
  for_each = {
    for listener in local.lb_listener_forward : listener.name => listener
  }
  ssl_policy      = each.value.ssl_policy
  port            = each.value.port
  protocol        = each.value.protocol
  certificate_arn = each.value.certificate_arn
  default_action {
    type             = each.value.default_action_type
    target_group_arn = aws_lb_target_group.app-lb-tg.arn
  }
  tags = {
    Name = "${each.value.name}_${var.environment}"
  }
}

resource "aws_lb_target_group_attachment" "lb-master-attach" {
  provider         = aws
  target_group_arn = aws_lb_target_group.app-lb-tg.arn
  target_id        = local.lb_target_group_attachment.target_id
  port             = local.lb_target_group_attachment.port
}
