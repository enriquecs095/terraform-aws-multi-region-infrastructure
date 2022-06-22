
terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region_master
  alias  = "region-master"
}

provider "aws" {
  region = var.region_worker
  alias  = "region-worker"
}