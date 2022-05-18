variable "profile" {
  type        = string
  default     = "default"
  description = "Name of the profile, only in local environment"
}

variable "environment" {
  type = string
  #default = "master"
  nullable    = false
  description = "Name of the environment"
}

variable "public_key" {
  type = string
  #default = "environments_key"
  nullable    = false
  description = "Name of the public key, it must be stored in each region"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}

variable "region-worker" {
  type    = string
  default = "us-west-2"
}

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "workers-count" {
  type    = number
  default = 1
}
variable "instance-type" {
  type    = string
  default = "t3.micro"
}

variable "webserver-port" {
  type    = number
  default = 80
}

variable "dns-name" {
  type    = string
  default = "ackleners.com."
}
