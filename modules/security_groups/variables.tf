variable "environment" {
  type        = string
  nullable    = false
  description = "Name of the current environment"
}

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
  description = "The ip ingress address for security group"
}

variable "webserver_port" {
  type    = number
  default = 80
  description = "Web server port allowed for security group"
}

variable vpc_1_id {
    type = string
    description = "The vpc id in us-east-1 region"
}

variable vpc_1_oregon_id {
    type = string
    description = "The vpc id in us-west-2 region"
}