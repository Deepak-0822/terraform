variable "ecr_repo_name" {}
variable "lambda_name" {}
variable "lambda_role_name" {}
variable "image_uri" {}
variable "memory_size" {
  default = 512
}
variable "timeout" {
  default = 10
}

variable "prefix" {}
variable "project_name" {}
variable "environment_type" {}

variable "region" {
  default = "us-east-1"
}