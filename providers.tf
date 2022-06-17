

provider "aws" {
  #profile = var.profile
  region = var.region-master
  alias  = "region-master"
}

provider "aws" {
  #profile = var.profile
  region = var.region-worker
  alias  = "region-worker"
}

/*
module "tunnel" {
  source = "./tunnel"
  providers = {
    aws.src = aws.region-master
    aws.dst = aws.region-worker
  }
}

terraform {
  required_providers {
    aws {
      source               = "hashicorp/aws"
      version              = ">= 2.7.0"
      configuration_alises = [aws.src, aws.dst]
    }
  }
}*/