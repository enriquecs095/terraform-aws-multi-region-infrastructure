#Create SG for LB, only TCP/80, TCP/443 and outbound access
resource "aws_security_group" "security_group" {
  provider    = aws.region
  name        = "${var.name}_${var.environment}"
  description = var.description
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.list_of_ingress_rules
    content {
      description = ingress.value["description"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.list_of_egress_rules
    content {
      description = egress.value["description"]
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }

  tags = {
    Name = "security_group_${var.name}_${var.environment}"
  }

}
