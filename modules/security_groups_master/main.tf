
#Create SG for allowing TCP/8080 from * and TCP/22 from your IP in us-east-1
resource "aws_security_group" "master-sg" {
  provider    = aws.region
  name        = "${var.name}_${var.environment}"
  description = var.description
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow 22 for our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description     = "Allow anyone on port 8080 for Jenkins"
    from_port       = var.webserver_port
    to_port         = var.webserver_port
    protocol        = "tcp"
    security_groups = [var.security_group_id]
  }
  ingress {
    description = "Allow traffic from us-west-2"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.1.0/24"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security_group_${var.name}_${var.environment}"
  }

}
