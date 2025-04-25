terraform {
  backend "s3" {
    bucket       = "demo-tfstate-testing"
    key          = "path/to/state"
    region       = "ap-south-1"
  }
}