variable "environment" {
  type        = string
  nullable    = false
  description = "Name of the current environment"
}

variable "webserver_port" {
  type        = number
  description = "Web server port allowed for application load balancer"
}

variable "sg_2_master_id" {
  type        = string
  description = "The id of the security group 2 in us-east-1"
}

variable "subnet_1_master_id" {
  type        = string
  description = "Subnet Id #1 of the us-east-1 region"
}

variable "subnet_2_master_id" {
  type        = string
  description = "Subnet Id #2 of the us-east-1 region"
}

variable "vpc_1_master_id" {
  type        = string
  description = "The vpc id in us-east-1 region"
}

variable "instance_1_master_id" {
  type        = string
  description = "The id of the instance 1 in us-east-1 region"
}

variable "acm_master_arn" {
  type        = string
  description = "The arn of the acm certificate in us-east-1"
}
