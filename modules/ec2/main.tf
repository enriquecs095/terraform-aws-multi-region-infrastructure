#Get Linux AMI ID using Simple Systems Manager (SSM) Parameter endpoint in the region given as parameter
data "aws_ssm_parameter" "linuxAMI" {
  provider = aws.region
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

/*
#Get Linux AMI ID using Simple Systems Manager (SSM) Parameter endpoint in us-west-2
data "aws_ssm_parameter" "linuxAMIOregon" {
  provider = aws.region-worker
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}*/

#Create and bootstrap EC2 instance
resource "aws_instance" "instance" {
  provider                    = aws.region
  count                       = var.instances_count
  ami                         = data.aws_ssm_parameter.linuxAMI.value
  instance_type               = var.instance_type
  key_name                    = var.public_key
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_groups_id
  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --region ${var.region} --instance-ids ${self.id} \
 && ansible-playbook  --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' master_ip=${var.master_private_ip} ansible_templates/${var.ansible_playbook_file}
EOF
  }
  tags = {
    Name = "instance_${var.name}_${var.environment}_${count.index + 1}"
  }

}

/*
#Create EC2 in us-west-2
resource "aws_instance" "jenkins-worker-oregon" {
  provider                    = aws.region-worker
  count                       = var.workers_count
  ami                         = data.aws_ssm_parameter.linuxAMIOregon.value
  instance_type               = var.instance_type
  key_name                    = var.public_key
  associate_public_ip_address = true
  subnet_id                   = var.subnet_1_worker_oregon_id
  vpc_security_group_ids      = [var.sg_1_worker_oregon_id]

  tags = {
    Name = join("_", ["jenkins_worker_tf", var.environment, count.index + 1])
  }

  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --region ${var.region_worker} --instance-ids ${self.id} \
&& ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name} master_ip=${aws_instance.jenkins-master.private_ip}' ansible_templates/jenkins-worker-sample.yml
EOF
  }

  depends_on = [aws_instance.jenkins-master]

}*/
