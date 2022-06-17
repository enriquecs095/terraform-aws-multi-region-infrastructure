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


#Create VPC in us-east-1
module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "my-vpc-1"
  cidr                 = "10.0.0.0/16"
  azs                  = [element(data.aws_availability_zones.azs.names, 0), element(data.aws_availability_zones.azs.names, 1)]
  public_subnets       = ["10.0.1.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
  create_igw           = true
  tags = {
    Name = join("_", ["master-vpc-jenkins", var.environment])
  }
}

#Create VPC in us-west-2
module "vpc2" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "my-vpc-2"
  cidr                 = "192.168.0.0/16"
  azs                  = ["us-west-2"]
  public_subnets       = ["192.168.1.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
  create_igw           = true
  tags = {
    "Name" = join("_", ["worker-vpc-jenkins", var.environment])
  }
}




#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}

module "lb_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  description = "Allow 443/80 all traffic to Jenkins SG"
  name        = "lb-sg-${var.environment}"
  vpc_id      = module.vpc1.vpc_id
  ingress_with_cidr_blocks = [
    {
      description = "Allow 443 from anywhere"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "Allow 80 from anywhere for redirections"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  tags = {
    Name = join("_", ["Worker-Region-RT", var.environment])
  }
}


module "jenkins_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  description = "Allow TCP/8080 & TCP/22"
  name        = "jenkins-sg-${var.environment}"
  vpc_id      = module.vpc1.vpc_id
  ingress_with_cidr_blocks = [
    {
      description = "Allow 22 for our public IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.external_ip
    },
    {
      description = "Allow traffic from us-west-2"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "192.168.1.0/24"
    },
  ]
  ingress_with_source_security_group_id = [
    {
      description              = "Allow anyone on port 8080 for Jenkins"
      from_port                = var.webserver-port
      to_port                  = var.webserver-port
      protocol                 = "tcp"
      source_security_group_id = module.lb_sg.security_group_id
    }

  ]

  egress_with_cidr_blocks = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  tags = {
    Name = join("_", ["Lb-sg-jenkins", var.environment])
  }
}

module "jenkins_sg_oregon" {
  source      = "terraform-aws-modules/security-group/aws"
  description = "Allow TCP/22 & and any port from master region"
  name        = "jenkins-sg-oregon-${var.environment}"
  vpc_id      = module.vpc2.vpc_id
  ingress_with_cidr_blocks = [
    {
      description = "Allow 22 from our public IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.external_ip
    },
    {
      description = "Allow traffic from us-east-1"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "10.0.1.0/24"
    },
  ]
  egress_with_cidr_blocks = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  tags = {
    Name = join("_", ["Lb-sg-worker", var.environment])
  }
}

module "peering_connection" {
  
  source  = "grem11n/vpc-peering/aws//examples/single-account-multi-region"
  version = "4.1.0"

  providers = {
    aws.region-master = aws.region-master
    aws.region-worker = aws.region-worker
  }

  this_vpc_id = module.vpc1.vpc_id
  peer_vpc_id = module.vpc2.vpc_id

  auto_accept_peering = true

  tags = {
    Name = join("_", ["peering_connection_tf", var.environment])
  }
}


module "ec2_instance_1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                        = "jenkins-master"
  associate_public_ip_address = true
  ami                         = data.aws_ssm_parameter.linuxAMI.value
  instance_type               = var.instance-type
  key_name                    = var.public_key
  monitoring                  = false
  vpc_security_group_ids      = [module.lb_sg.security_group_id]
  subnet_id                   = element(module.vpc1.public_subnets, 0)
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
}


module "ec2_instance_2" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = "jenkins-worker-oregon"
  associate_public_ip_address = true
  ami                         = data.aws_ssm_parameter.linuxAMIOregon.value
  instance_type               = var.instance-type
  key_name                    = var.public_key
  monitoring                  = false
  vpc_security_group_ids      = [module.jenkins_sg_oregon.security_group_id]
  subnet_id                   = element(module.vpc2.public_subnets, 0)
  count                       = var.workers-count

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

  depends_on = [module.ec2_instance_1]

}

