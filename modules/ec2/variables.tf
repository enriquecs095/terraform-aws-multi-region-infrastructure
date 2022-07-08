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

variable "instances_count" {
  description = "The starting value for the quantity of instances"
  type        = number
}

variable "region" {
  description = "Region of the vpc"
  type        = string
}

variable "environment" {
  description = "Name of the current environment"
  type        = string
  nullable    = false
}

variable "subnet_id" {
  description = "Subnet Id for the instance"
  type        = string
}

variable "security_groups_id" {
  description = "The id of the security group"
  type        = list(string)
}

variable "ansible_playbook_file" {
  description = "The name of the ansible playbook file"
  type        = string
}

variable "master_private_ip" {
  description = "The ip address of the master instance"
  type        = string
}

variable "name" {
  description = "Name of the resource"
  type        = string
}
