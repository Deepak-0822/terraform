variable "sns_arn" {
  description = "Email to receive console login alerts"
  type        = list(string)
}

variable "cloudtrail_s3_bucket" {
  description = "S3 bucket name to store CloudTrail logs"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch Log Group name"
  type        = string
}
