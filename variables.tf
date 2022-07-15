variable "environment" {
  description = "Name of the current environment"
  type        = string
  nullable    = false
}

variable "region_master" {
  description = "Name of the region where the resources will be stored"
  type        = string
  default     = "us-east-1"
}

variable "region_worker" {
  description = "Name of the region where the resources will be stored"
  type        = string
  default     = "us-west-2"
}

variable "public_key" {
  description = "Name of the public key, it must be stored in each region"
  type        = string
  nullable    = false
}

variable "list_of_security_groups_master" {
  description = "List of security groups"
  type = list(object({
    name        = string
    description = string
    list_of_rules = list(object({
      name                       = string
      description                = string
      protocol                   = string
      from_port                  = number
      to_port                    = number
      cidr_blocks                = list(string)
      source_security_group_name = string
      type                       = string
    }))
  }))
  default = [
    {
      name        = "sg_master_1"
      description = "Allow 443/80 all traffic to Jenkins SG"
      list_of_rules = [
        {
          name                       = "ingress_rule_1"
          description                = "Allow 443 from anywhere"
          protocol                   = "tcp"
          from_port                  = 443
          to_port                    = 443
          cidr_blocks                = ["0.0.0.0/0"]
          source_security_group_name = null
          type                       = "ingress"
        },
        {
          name                       = "ingress_rule_2"
          description                = "Allow 80 from anywhere"
          protocol                   = "tcp"
          from_port                  = 80
          to_port                    = 80
          cidr_blocks                = ["0.0.0.0/0"]
          source_security_group_name = null
          type                       = "ingress"
        },
        {
          name                       = "egress_rule_1"
          description                = "Allow all outbound traffic"
          protocol                   = "-1"
          from_port                  = 0
          to_port                    = 0
          cidr_blocks                = ["0.0.0.0/0"]
          source_security_group_name = null
          type                       = "egress"
        }
      ]
    },
    {
      id          = 2
      name        = "sg_master_2"
      description = "Allow TCP/8080 & TCP/22"
      list_of_rules = [
        {
          name                       = "ingress_rule_3"
          description                = "Allow 22 for our public IP"
          protocol                   = "tcp"
          from_port                  = 22
          to_port                    = 22
          cidr_blocks                = ["0.0.0.0/0"]
          source_security_group_name = null
          type                       = "ingress"
        },
        {
          name                       = "ingress_rule_5"
          description                = "Allow traffic from us-west-2"
          protocol                   = "-1"
          from_port                  = 0
          to_port                    = 0
          cidr_blocks                = ["192.168.1.0/24"]
          source_security_group_name = null
          type                       = "ingress"
        },
        {
          //also change to 8080 if you want to use Jenkins
          name                       = "ingress_rule_4"
          description                = "Allow anyone on port 80"
          protocol                   = "tcp"
          from_port                  = 80
          to_port                    = 80
          cidr_blocks                = []
          source_security_group_name = "sg_master_1"
          type                       = "ingress"
        },
        {
          name                       = "egress_rule_2"
          description                = "Allow all outbound traffic"
          protocol                   = "-1"
          from_port                  = 0
          to_port                    = 0
          cidr_blocks                = ["0.0.0.0/0"]
          source_security_group_name = null
          type                       = "egress"
        }
      ]
    },
  ]
}

variable "list_of_security_groups_worker" {
  description = "List of security groups"
  type = list(object({
    name        = string
    description = string
    list_of_rules = list(object({
      name                       = string
      description                = string
      protocol                   = string
      from_port                  = number
      to_port                    = number
      cidr_blocks                = list(string)
      source_security_group_name = string
      type                       = string
    }))
  }))
  default = [
    {
      name        = "sg_worker_1"
      description = "Allow 22 all traffic to Jenkins SG"
      list_of_rules = [
        {
          name                       = "ingress_rule_1"
          description                = "Allow 22 from our public IP"
          protocol                   = "tcp"
          from_port                  = 22
          to_port                    = 22
          cidr_blocks                = ["0.0.0.0/0"]
          source_security_group_name = null
          type                       = "ingress"
        },
        {
          name                       = "ingress_rule_2"
          description                = "Allow traffic from us-east-1"
          protocol                   = "-1"
          from_port                  = 0
          to_port                    = 0
          cidr_blocks                = ["10.0.1.0/24"]
          source_security_group_name = null
          type                       = "ingress"
        },
        {
          name                       = "egress_rule_1"
          description                = "Allow all outbound traffic"
          protocol                   = "-1"
          from_port                  = 0
          to_port                    = 0
          cidr_blocks                = ["0.0.0.0/0"]
          source_security_group_name = null
          type                       = "egress"
        }
      ]
    },
  ]
}

variable "list_of_subnets_master" {
  description = "List of subnets for the master region"
  type = list(object({
    id                = number
    name              = string
    description       = string
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    {
      id                = 1
      name              = "subnet_master_1"
      description       = "Subnet #1"
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    },
    {
      id                = 2
      name              = "subnet_master_2"
      description       = "Subnet #2"
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    },
  ]
}

variable "list_of_subnets_worker" {
  description = "List of subnets for the worker region"
  type = list(object({
    id                = number
    name              = string
    description       = string
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    {
      id                = 1
      name              = "subnet_worker_1"
      description       = "Subnet #1"
      cidr_block        = "192.168.1.0/24"
      availability_zone = "us-west-2a"
    }
  ]
}

variable "list_of_vpcs" {
  description = "List of VPCs"
  type = list(object({
    id           = number
    name         = string
    description  = string
    cidr_block   = string
    dns_support  = bool
    dns_hostname = bool
  }))
  default = [
    {
      id           = 1
      name         = "vpc_1"
      description  = "VPC #1"
      cidr_block   = "10.0.0.0/16"
      dns_support  = true
      dns_hostname = true
    },
    {
      id           = 2
      name         = "vpc_2"
      description  = "VPC #2"
      cidr_block   = "192.168.0.0/16"
      dns_support  = true
      dns_hostname = true
    }
  ]
}

variable "list_of_instances" {
  description = "List of instances"
  type = list(object({
    name                        = string
    security_groups             = list(string)
    subnet                      = string
    instance_type               = string
    associate_public_ip_address = bool
    ami_name                    = string
    instances_count             = number
    ansible_templates           = string
    master_ip                   = string
    private_ip                  = string
  }))
  default = [
    {
      name                        = "instance_master_1"
      security_groups             = ["sg_master_2"]
      subnet                      = "subnet_master_1"
      instance_type               = "t3.micro"
      associate_public_ip_address = true
      ami_name                    = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
      instances_count             = 1
      ansible_templates           = "ansible_templates/jenkins-master-sample.yml"
      master_ip                   = null
      private_ip                  = "10.0.1.12"
    },
    {
      name                        = "instance_worker_1"
      security_groups             = ["sg_worker_1"]
      subnet                      = "subnet_worker_1"
      instance_type               = "t3.micro"
      associate_public_ip_address = true
      ami_name                    = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
      instances_count             = 1
      ansible_templates           = "ansible_templates/jenkins-worker-sample.yml"
      master_ip                   = "10.0.1.12"
      private_ip                  = "192.168.1.12"
    },
  ]

}


variable "list_of_load_balancers" {
  description = "List of load balancers"
  type = list(object({
    name                 = string
    internal             = bool
    load_balancer_type   = string
    security_groups_list = list(string)
    subnets_list         = list(string)
    lb_target_group = object({
      name        = string
      port        = string
      target_type = string
      vpc_id      = string
      protocol    = string
      health_check = object({
        enabled  = bool
        path     = string
        interval = number
        port     = number
        protocol = string
        matcher  = string
      })
    })
    lb_listener_forward = list(object({
      name                = string
      port                = string
      protocol            = string
      default_action_type = string
      target_group_arn    = string
      ssl_policy          = string
      certificate_arn     = string
    }))
    lb_listener_redirect = list(object({
      name                = string
      port                = string
      protocol            = string
      default_action_type = string
      redirect = object({
        status_code = string
        port        = number
        protocol    = string
      })
    }))
    lb_target_group_attachment = object({
      target_id = string
      port      = number
    })
  }))
  default = [
    {
      //only allowed hyphen nor underscore in name
      name                 = "lb-master-1"
      internal             = false
      load_balancer_type   = "application"
      security_groups_list = ["sg_master_1"]
      subnets_list         = ["subnet_master_1", "subnet_master_2"]
      lb_target_group = {
        //only allowed hyphen nor underscore in name
        name        = "target-group-1"
        port        = "80"
        target_type = "instance"
        vpc_id      = "vpc_1"
        protocol    = "HTTP"
        health_check = {
          enabled  = true
          path     = "/"
          interval = 10
          port     = 80
          protocol = "HTTP"
          matcher  = "200-299"
        }
      }
      lb_listener_redirect = [
        {
          name                = "lb_listener_1"
          port                = "80"
          protocol            = "HTTP"
          default_action_type = "redirect"
          redirect = {
            status_code = "HTTP_301"
            port        = 443
            protocol    = "HTTPS"
          }
        },
      ]
      lb_listener_forward = [
        {
          name                = "lb_listener_2"
          port                = "443"
          protocol            = "HTTPS"
          default_action_type = "forward"
          target_group_arn    = "target_group_1"
          ssl_policy          = "ELBSecurityPolicy-2016-08"
          certificate_arn     = "acm_certificate_1"
        },
      ]
      lb_target_group_attachment = {
        target_id = "instance_master_1"
        port      = 80
      }
    },
  ]
}


variable "map_of_acm_certificate" {
  description = "List of ACM certificates"
  type = map(object({
    name                   = string
    dns_name               = string
    validation_method      = string
    route53_record_type    = string
    ttl                    = number
    evaluate_target_health = bool
  }))
  default = {
    "acm_certificate_1" = {
      name                   = "acm_certificate_1"
      dns_name               = "ackleners.com."
      validation_method      = "DNS"
      route53_record_type    = "A"
      ttl                    = 60
      evaluate_target_health = true
    },
  }

}