variable "user_pool_name" {}
variable "app_client_name" {}
variable "domain_prefix" {}

variable "api_id" {
  description = "API Gateway ID for callback URL"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

