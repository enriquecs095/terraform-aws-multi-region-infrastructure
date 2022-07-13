#Get Linux AMI ID using Simple Systems Manager (SSM) Parameter endpoint in the region given as parameter
data "aws_ssm_parameter" "linuxAMI" {
  provider = aws
  name     = var.instance_data.ami_name
}

data "aws_route_tables" "route-table-resource" {
  vpc_id = var.vpc_id
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
  private_ip                  = var.instance_data.private_ip
  tags = {
    Name = "${var.instance_data.name}_${var.environment}"
  }

  provisioner "local-exec" {
    command = (var.instance_data.master_ip == null ? <<EOF
  aws ec2 wait instance-status-ok --region ${var.region} --instance-ids ${self.id} \
 && ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ${var.instance_data.ansible_templates} \
 EOF
      :
      <<EOF
aws ec2 wait instance-status-ok --region ${var.region} --instance-ids ${self.id} \
&& ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name} master_ip=${var.instance_data.master_ip}' ${var.instance_data.ansible_templates} \
EOF
    )
  }

  depends_on = [data.aws_route_tables.route-table-resource]

}
