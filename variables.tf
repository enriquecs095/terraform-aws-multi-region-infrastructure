variable "environment" {
  type        = string
  nullable    = false
  description = "Name of the current environment"
}

variable "region_master" {
  type    = string
  default = "us-east-1"
}

variable "region_worker" {
  type    = string
  default = "us-west-2"
}

variable "public_key" {
  type        = string
  nullable    = false
  description = "Name of the public key, it must be stored in each region"
}
