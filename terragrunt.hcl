terraform {
  source = "./"
}

remote_state {
  backend = "s3"
  config  = {
    encrypt        = true
    bucket         = "demo-tfstate-testing"
    key            = "aws/infra/terraform.tfstate"
    region         = "ap-south-1"
  }
}