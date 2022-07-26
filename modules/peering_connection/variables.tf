variable "environment" {
  description = "Name of the current environment"
  type        = string
  nullable    = false
}

variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "vpc_id_master" {
    description = "The id of the vpc in us-east-1"
    type = string
}

variable "vpc_id_worker" {
    description = "The id of the vpc in us-west-2"
    type = string
}

variable "region_worker" {
  description = "Name of the worker peer region for the peering connection"
  type        = string
}