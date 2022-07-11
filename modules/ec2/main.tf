#Get Linux AMI ID using Simple Systems Manager (SSM) Parameter endpoint in the region given as parameter
data "aws_ssm_parameter" "linuxAMI" {
  provider = aws
  name     = var.instance_data.ami_name
}

#Create and bootstrap EC2 instance
resource "aws_instance" "instances" {
  provider                    = aws
  count                       = var.instance_data.instances_count
  ami                         = data.aws_ssm_parameter.linuxAMI.value
  instance_type               = var.instance_data.instance_type
  key_name                    = var.public_key
  associate_public_ip_address = var.instance_data.associate_public_ip_address
  subnet_id                   = var.subnets_id["${var.instance_data.subnet}_${var.environment}"]
  vpc_security_group_ids      = local.security_groups_list
  
  tags = {
    Name = "${var.name}_${var.environment}_${count.index + 1}"
  }
}
