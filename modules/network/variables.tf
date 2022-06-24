variable "region_worker" {
  description = "Region of the vpc worker"
  type        = string
}

variable "environment" {
  description = "Name of the current environment"
  type        = string
  nullable    = false
}

