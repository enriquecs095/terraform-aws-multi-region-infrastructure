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

variable "list_of_ingress_rules_lb" {
  description = "List of ingress rules"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
    {
      description = "Allow 443 from anywhere"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow 80 from anywhere for redirections"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

variable "list_of_egress_rules_lb" {
  description = "List of egress rules"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

variable "list_of_ingress_rules_worker" {
  description = "List of ingress rules for the worker region"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
    {
      description = "Allow 22 from our public IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow traffic from us-east-1"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["10.0.1.0/24"]
    },
  ]
}

variable "list_of_egress_rules_worker" {
  description = "List of egress rules for the worker region"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
