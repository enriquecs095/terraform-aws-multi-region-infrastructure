terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    region  = "us-east-1"
    key     = "master/terraformstatefile"
    bucket  = "terraformstatebucket01234"
  }
}

