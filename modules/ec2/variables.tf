variable "public_key" {
  description = "Name of the public key, it must be stored in each region"
  type        = string
  nullable    = false
}

variable "instance_type" {
  description = "Type of the instance resource"
  type        = string
  default     = "t3.micro"
}

variable "environment" {
  description = "Name of the current environment"
  type        = string
  nullable    = false
}

variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "region" {
  description = "Name of the region where the resources will be stored"
  type        = string
}

variable "instance_data" {
  description = "The data of the instance"
  type = object({
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
  })
}

variable "security_groups_list" {
  description = "The list of the security groups"
  type        = map(string)
}

variable "subnets_id" {
  description = "The list of the subnets"
  type        = map(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
