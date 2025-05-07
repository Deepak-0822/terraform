resource "aws_s3_bucket" "this" {
  bucket = var.name
}

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.this.id

  lambda_function {
    lambda_function_arn = var.lambda_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.prefix
  }

  depends_on = [var.lambda_permission]
}
