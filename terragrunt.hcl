terraform {
  backend "s3" {
    bucket = "demo-tfstate-testing"
    key    = "path/to/my/key"
    region = "ap-south-1"
  }
}