resource "aws_s3_bucket" "image_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.image_bucket.id

  lambda_function {
    lambda_function_arn = var.lambda_arn
    events              = ["s3:ObjectCreated:*"]
    id                  = var.s3_notification_id
  }

  depends_on = [var.lambda_permission]
}

output "bucket_name" {
  value = aws_s3_bucket.image_bucket.bucket
}
