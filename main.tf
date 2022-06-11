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


module "ec2_instance-1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "jenkins-master"
  associate_public_ip_address=true
  ami                    = data.aws_ssm_parameter.linuxAMI.value
  instance_type          = var.instance-type
  key_name               = var.public_key
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  subnet_id              = aws_subnet.subnet_1.id
/*
  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id} \
 && ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/jenkins-master-sample.yml
EOF
  }*/

  tags = {
    Name = join("_", ["jenkins_master_tf", var.environment])
  }
  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]

}


module "ec2_instance-2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  name = "jenkins-worker-oregon"
  associate_public_ip_address=true
  ami                    = data.aws_ssm_parameter.linuxAMIOregon.value
  instance_type          = var.instance-type
  key_name               = var.public_key
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.jenkins-sg-oregon.id]
  subnet_id              = aws_subnet.subnet_1_oregon.id
  count = var.workers-count

  tags = {
    Name = join("_", ["jenkins_worker_tf", var.environment, count.index + 1])
  }
/*
  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --region ${var.region-worker} --instance-ids ${self.id} \
&& ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name} master_ip=${aws_instance.jenkins-master.private_ip}' ansible_templates/jenkins-worker-sample.yml
EOF
  }*/

depends_on = [aws_main_route_table_association.set-worker-default-rt-assoc, aws_instance.jenkins-master]

}

#Create VPC in us-east-1
module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc-1"
  cidr = "10.0.0.0/16"
  azs = [element(data.aws_availability_zones.azs.names, 0),element(data.aws_availability_zones.azs.names, 1)]
  public_subnets  = ["10.0.1.0/24","10.0.2.0/24"]
  enable_dns_hostnames = true
  enable_dns_support = true
  create_igw = true
  tags = {
  Name = join("_", ["master-vpc-jenkins", var.environment])
  }
}

#Create VPC in us-west-2
module "vpc2" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc-2"
  cidr = "192.168.0.0/16"
  azs = ["us-west-2"]
  public_subnets  = ["192.168.1.0/24"]
  enable_dns_hostnames = true
  enable_dns_support = true
  create_igw = true
  tags = {
    "Name" = join("_", ["worker-vpc-jenkins", var.environment])
  }
}

#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}