variable "bucket_name" {
  default = "image-upload-bucket"
}

variable "topic_name" {
  default = "image-processing-updates"
}

variable "lambda_name" {
  default = "image-resize-lambda"
}
