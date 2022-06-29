
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

variable "vpcs" {
  description = "VPC's arguments"
  type = object({
    id           = number
    description  = string
    cidr_block   = string
    dns_support  = bool
    dns_hostname = bool
  })
}
