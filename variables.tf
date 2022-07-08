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

variable "dns_name" {
  description = "DNS chosen for the aws infrastructure environment"
  type        = string
  default     = "ackleners.com."
}

variable "list_of_security_groups_master" {
  description = "List of security groups"
  type = list(object({
    name        = string
    description = string
    list_of_rules = list(object({
      name                     = string
      description              = string
      protocol                 = string
      from_port                = number
      to_port                  = number
      cidr_blocks              = list(string)
      type                     = string
    }))
  }))
  default = [
    {
      name        = "sg_master_1"
      description = "Allow 443/80 all traffic to Jenkins SG"
      list_of_rules = [
        {
          name                     = "ingress_rule_1"
          description              = "Allow 443 from anywhere"
          protocol                 = "tcp"
          from_port                = 443
          to_port                  = 443
          cidr_blocks              = ["0.0.0.0/0"]
          type                     = "ingress"
        },
        {
          name                     = "ingress_rule_2"
          description              = "Allow 80 from anywhere"
          protocol                 = "tcp"
          from_port                = 80
          to_port                  = 80
          cidr_blocks              = ["0.0.0.0/0"]
          type                     = "ingress"
        },
        {
          name                     = "egress_rule_1"
          description              = "Allow all outbound traffic"
          protocol                 = "-1"
          from_port                = 0
          to_port                  = 0
          cidr_blocks              = ["0.0.0.0/0"]
          type                     = "egress"
        }
      ]
    },
    {
      id          = 2
      name        = "sg_master_2"
      description = "Allow TCP/8080 & TCP/22"
      list_of_rules = [
        {
          name                     = "ingress_rule_3"
          description              = "Allow 22 for our public IP"
          protocol                 = "tcp"
          from_port                = 22
          to_port                  = 22
          cidr_blocks              = ["0.0.0.0/0"]
          type                     = "ingress"
        },
        {
          name                     = "ingress_rule_4"
          description              = "Allow traffic from us-west-2"
          protocol                 = "tcp"
          from_port                = 8080
          to_port                  = 8080
          cidr_blocks              = ["0.0.0.0/0"]
          type                     = "ingress"
          //          security_groups_dependency = "sg_master_1" cidr_blocks va empty
        },
        {
          name                     = "ingress_rule_5"
          description              = "Allow traffic from us-west-2"
          protocol                 = "-1"
          from_port                = 0
          to_port                  = 0
          cidr_blocks              = ["192.168.1.0/24"]
          type                     = "ingress"
        },
        {
          name                     = "egress_rule_2"
          description              = "Allow all outbound traffic"
          protocol                 = "-1"
          from_port                = 0
          to_port                  = 0
          cidr_blocks              = ["0.0.0.0/0"]
          type                     = "egress"
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
      name                     = string
      description              = string
      protocol                 = string
      from_port                = number
      to_port                  = number
      cidr_blocks              = list(string)
      type                     = string
    }))
  }))
  default = [
    {
      name        = "sg_worker_1"
      description = "Allow 22 all traffic to Jenkins SG"
      list_of_rules = [
        {
          name                     = "ingress_rule_1"
          description              = "Allow 22 from our public IP"
          protocol                 = "tcp"
          from_port                = 22
          to_port                  = 22
          cidr_blocks              = ["0.0.0.0/0"]
          type                     = "ingress"
        },
        {
          name                     = "ingress_rule_2"
          description              = "Allow traffic from us-east-1"
          protocol                 = "-1"
          from_port                = 0
          to_port                  = 0
          cidr_blocks              = ["10.0.1.0/24"]
          type                     = "ingress"
        },
        {
          name                     = "egress_rule_1"
          description              = "Allow all outbound traffic"
          protocol                 = "-1"
          from_port                = 0
          to_port                  = 0
          cidr_blocks              = ["0.0.0.0/0"]
          type                     = "egress"
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
