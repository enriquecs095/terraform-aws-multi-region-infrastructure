
variable "environment" {
  description = "Name of the current environment"
  type        = string
  nullable    = false
}

variable "cidr_block_vpc" {
  description = "CIDR block for the VPCs"
  type        = string
}

variable "dns_support" {
  description = "Enable DNS support"
  type        = bool
}

variable "dns_hostname" {
  description = "Enable DNS hostname"
  type        = bool
}

variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "cidr_block_subnets" {
  description = "IP addresses of the cidr block for the subnets"
  type        = list(string)
}

variable "availability_zone_index" {
  description = "Index of the availability zone"
  type        = number
}

variable "count_subnet" {
  description = "Number of subnets"
  type        = number
}

variable "cidr_block_route_table" {
  description = "CIDR block for the route table"
  type        = string
}

variable "peering_connection_id" {
  description = "ID of the peering connection"
  type        = string
}

