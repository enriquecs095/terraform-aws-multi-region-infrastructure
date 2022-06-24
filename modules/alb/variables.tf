variable "environment" {
  description = "Name of the current environment"
  type        = string
  nullable    = false
}

variable "webserver_port" {
  description = "Web server port allowed for application load balancer"
  type        = number
}

variable "sg_2_master_id" {
  description = "The id of the security group 2 in us-east-1"
  type        = string
}

variable "subnet_1_master_id" {
  description = "Subnet Id #1 of the us-east-1 region"
  type        = string
}

variable "subnet_2_master_id" {
  description = "Subnet Id #2 of the us-east-1 region"
  type        = string
}

variable "vpc_1_master_id" {
  description = "The vpc id in us-east-1 region"
  type        = string
}

variable "instance_1_master_id" {
  description = "The id of the instance 1 in us-east-1 region"
  type        = string
}

variable "acm_master_arn" {
  description = "The arn of the acm certificate in us-east-1"
  type        = string
}
