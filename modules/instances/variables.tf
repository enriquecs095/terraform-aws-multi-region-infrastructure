variable "public_key" {
  type        = string
  nullable    = false
  description = "Name of the public key, it must be stored in each region"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
  description = "Type of the instance resource"
}

variable "workers_count" {
  type    = number
  default = 1
  description = "The starting value for the quantity of worker instances"

}

variable "region_master" {
  type        = string
  description = "Region of the vpc master"
}

variable "region_worker" {
  type        = string
  description = "Region of the vpc worker"
}

variable "environment" {
  type        = string
  nullable    = false
  description = "Name of the current environment"
}

variable "subnet_1_master_id" {
  type        = string
  description = "Subnet Id of the us-east-1 region"
}

variable "subnet_1_worker_oregon_id" {
  type        = string
  description = "Subnet Id of the us-west-2 region"
}

variable "sg_1_master_id" {
  type        = string
  description = "The security group id of the us-east-1 region"

}

variable "sg_1_worker_oregon_id" {
  type        = string
  description = "The security group id of the us-west-2 region"
}
 
