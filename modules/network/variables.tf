
variable "region_worker" {
  type        = string
  description = "Region of the vpc worker"
}

variable "environment" {
  type        = string
  nullable    = false
  description = "Name of the current environment"
}

