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

#Create key-pair for logging into EC2 in us-east-1
#resource "aws_key_pair" "master_key" {
#  provider   = aws.region-master
#  key_name   = "jenkins"
#  public_key = file("~/.ssh/id_rsa.pub")
#}

#Create key-pair for logging into EC2 in us-west-2
#resource "aws_key_pair" "worker_key" {
#  provider   = aws.region-worker
#  key_name   = "jenkins"
#  public_key = file("~/.ssh/id_rsa.pub")
#}

#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "jenkins-master" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxAMI.value
  instance_type               = var.instance-type
  key_name                    = var.public_key
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id

  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id} \
 && ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/jenkins-master-sample.yml

EOF
  }
  tags = {
    Name = join("_", ["jenkins_master_tf", var.environment])
  }
  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]
}

#Create EC2 in us-west-2
resource "aws_instance" "jenkins-worker-oregon" {
  provider                    = aws.region-worker
  count                       = var.workers-count
  ami                         = data.aws_ssm_parameter.linuxAMIOregon.value
  instance_type               = var.instance-type
  key_name                    = var.public_key
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg-oregon.id]
  subnet_id                   = aws_subnet.subnet_1_oregon.id

  tags = {
    Name = join("_", ["jenkins_worker_tf", var.environment, count.index + 1])
  }

  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --region ${var.region-worker} --instance-ids ${self.id} \
&& ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name} master_ip=${aws_instance.jenkins-master.private_ip}' ansible_templates/jenkins-worker-sample.yml
EOF
  }

  depends_on = [aws_main_route_table_association.set-worker-default-rt-assoc, aws_instance.jenkins-master]

}
