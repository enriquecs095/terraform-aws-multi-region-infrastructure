variable "environment" {
  description = "Name of the current environment"
  type        = string
  nullable    = false
}

variable "external_ip" {
  description = "The ip ingress address for security group"
  type        = string
  default     = "0.0.0.0/0"
}

variable "webserver_port" {
  description = "Web server port allowed for security group"
  type        = number
}

variable "vpc_1_master_id" {
  description = "The vpc id in us-east-1 region"
  type        = string
}

variable "vpc_1_worker_oregon_id" {
  description = "The vpc id in us-west-2 region"
  type        = string
}
