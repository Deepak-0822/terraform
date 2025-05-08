output "lambda_arn" {
  value = aws_lambda_function.this.arn
}

output "lambda_permission" {
  value = aws_lambda_permission.allow_s3
}
