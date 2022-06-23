variable "environment" {
  type        = string
  nullable    = false
  description = "Name of the current environment"
}

variable "region_master" {
  type        = string
  default     = "us-east-1"
  description = "Name of the region where the resources will be stored"
}

variable "region_worker" {
  type        = string
  default     = "us-west-2"
  description = "Name of the region where the resources will be stored"
}

variable "public_key" {
  type        = string
  nullable    = false
  description = "Name of the public key, it must be stored in each region"
}

variable "webserver_port" {
  type        = number
  default     = 80
  description = "Web server port allowed for security group and load balancer"
}

variable "dns_name" {
  type        = string
  default     = "ackleners.com."
  description = "DNS chosen for the aws infrastructure environment"
}
