variable "environment" {
  description = "Name of the current environment"
  type        = string
  nullable    = false
}

variable "vpc_id" {
  description = "The id of the vpc in us-east-1"
  type = string
}

variable "external_ip" {
  description = "The ip ingress address for security group in master region"
  type        = string
  default     = "0.0.0.0/0"
}

variable "webserver_port" {
  description = "Web server port allowed for security group in master region"
  type        = number
  default     = 80
}

variable "security_group_id" {
    description = "The id of the security group for the master region"
    type        = string
}

variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type = string
}
