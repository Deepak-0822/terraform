variable "bucket_name" {
  description = "The name of the S3 bucket for CloudTrail logs"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID for CloudTrail"
  type        = string
}
