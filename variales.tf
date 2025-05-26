variable "ecr_repo_name" {}
variable "lambda_name" {}
variable "lambda_role_name" {}
variable "image_uri" {}
variable "memory_size" {
  default = 512
}
variable "timeout" {
  default = 60
}

variable "cognito_domain_prefix" {
  default = "helloworld-demo-unique"
}

variable "region" {
  default = "us-east-1"
}


variable "cloudtrail_s3_bucket" {
  description = "S3 bucket to store CloudTrail logs"
  type        = string
  default     = "demo-tfstate-test"
}

variable "log_group_name" {
  description = "CloudWatch Logs group name"
  default     = "/aws/cloudtrail/login-events"
}
