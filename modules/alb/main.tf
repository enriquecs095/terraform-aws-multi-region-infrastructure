resource "aws_lb" "application-lb" {
  provider           = aws.region-master
  name               = "jenkins-lb-${var.environment}" 
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_2_master_id]
  subnets            = [var.subnet_1_master_id, var.subnet_2_master_id]
  tags = {
    Name = join("_", ["Jenkins-LB", var.environment])
  }
}

resource "aws_lb_target_group" "app-lb-tg" {
  provider    = aws.region-master
  name        = "app-lb-tg-${var.environment}"
  port        = var.webserver_port
  target_type = "instance"
  vpc_id      = var.vpc_1_master_id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    path     = "/"
    interval = 10
    port     = var.webserver_port
    protocol = "HTTP"
    matcher  = "200-299"

  }
  tags = {
    Name = join("_", ["jenkins-target-group", var.environment])
  }

}

resource "aws_lb_listener" "jenkins-listener-http" {
  provider          = aws.region-master
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    #target_group_arn = aws_lb_target_group.app-lb-tg.arn
    #type             = "forward"
    type = "redirect"
    redirect {
      status_code = "HTTP_301"
      port        = "443"
      protocol    = "HTTPS"
    }
  }
}

resource "aws_lb_listener" "jenkins-listener-https" {
  provider          = aws.region-master
  load_balancer_arn = aws_lb.application-lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.acm_master_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.arn
  }
}


resource "aws_lb_target_group_attachment" "jenkins-master-attach" {
  provider         = aws.region-master
  target_group_arn = aws_lb_target_group.app-lb-tg.arn
  target_id        = var.instance_1_master_id
  port             = var.webserver_port
}
