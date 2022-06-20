
variable "region-master" {
  type    = string
  description = "Region of the vpc master"
}

variable "region-worker" {
  type    = string
    description = "Region of the vpc worker"
}

variable "environment" {
  type        = string
  nullable    = false
  description = "Name of the environment"
}

