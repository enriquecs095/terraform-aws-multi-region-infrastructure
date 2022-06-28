variable "environment" {
  description = "Name of the current environment"
  type        = string
  nullable    = false
}

variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "list_of_ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "list_of_egress_rules" {
  description = "List of egress rules"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "vpc_id" {
  description = "The id of the vpc in us-east-1"
  type = string
}

variable "description" {
  description = "Description of the security group"
  type = string
}