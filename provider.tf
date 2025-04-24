terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "demo-tfstate-testing"
    key    = "path/to/my/key"
    region = "ap-south-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}