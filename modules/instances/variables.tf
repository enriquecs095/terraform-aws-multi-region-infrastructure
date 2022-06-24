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

variable "workers_count" {
  description = "The starting value for the quantity of worker instances"
  type        = number
  default     = 1
}

variable "region_master" {
  description = "Region of the vpc master"
  type        = string
}

variable "region_worker" {
  description = "Region of the vpc worker"
  type        = string
}

variable "environment" {
  description = "Name of the current environment"
  type        = string
  nullable    = false
}

variable "subnet_1_master_id" {
  description = "Subnet Id of the us-east-1 region"
  type        = string
}

variable "subnet_1_worker_oregon_id" {
  description = "Subnet Id of the us-west-2 region"
  type        = string
}

variable "sg_1_master_id" {
  description = "The security group id of the us-east-1 region"
  type        = string
}

variable "sg_1_worker_oregon_id" {
  description = "The security group id of the us-west-2 region"
  type        = string
}

