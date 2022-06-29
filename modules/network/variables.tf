
variable "environment" {
  description = "Name of the current environment"
  type        = string
  nullable    = false
}

variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "cidr_block_route_table" {
  description = "CIDR block for the route table"
  type        = string
}

variable "peering_connection_id" {
  description = "ID of the peering connection"
  type        = string
}

variable "subnets" {
  description = "List of subnets"
  type = list(object({
    id                = number
    description       = string
    cidr_block        = string
    availability_zone = number
  }))
}

variable "vpc" {
  description = "VPC's arguments"
  type = object({
    id           = number
    description  = string
    cidr_block   = string
    dns_support  = bool
    dns_hostname = bool
  })
}

variable "security_groups" {
  description = "List of security groups"
  type = list(object({
    id          = number
    name        = string
    description = string
    list_of_ingress_rules = list(object({
      description = string
      protocol    = string
      from_port   = number
      to_port     = number
      cidr_blocks  = list(string)
    }))
    list_of_egress_rules = list(object({
      description = string
      protocol    = string
      from_port   = number
      to_port     = number
      cidr_blocks  = list(string)
    }))
  }))
}
