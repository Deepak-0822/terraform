data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.lambda_source_dir
  output_path = "${path.module}/lambda_function.zip"
  excludes    = ["package.json", "package-lock.json", "node_modules/.package-lock.json"]
}

resource "aws_lambda_function" "this" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.function_name
  role             = var.iam_role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "Node.js 18x"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 30

  environment {
    variables = {
      DEST_BUCKET = var.dest_bucket
      SNS_TOPIC   = var.sns_topic_arn
    }
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.source_bucket_arn
}
