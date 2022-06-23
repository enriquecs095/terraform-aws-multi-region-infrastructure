#Get Linux AMI ID using Simple Systems Manager (SSM) Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAMI" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Get Linux AMI ID using Simple Systems Manager (SSM) Parameter endpoint in us-west-2
data "aws_ssm_parameter" "linuxAMIOregon" {
  provider = aws.region-worker
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "jenkins-master" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxAMI.value
  instance_type               = var.instance_type
  key_name                    = var.public_key
  associate_public_ip_address = true
  subnet_id                   = var.subnet_1_master_id
  vpc_security_group_ids      = [var.sg_1_master_id]

  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --region ${var.region_master} --instance-ids ${self.id} \
 && ansible-playbook  --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/jenkins-master-sample.yml
EOF
  }
  tags = {
    Name = join("_", ["jenkins_master_tf", var.environment])
  }

}

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

}
