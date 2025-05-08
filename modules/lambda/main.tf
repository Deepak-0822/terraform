resource "aws_lambda_function" "this" {
  filename         = "${path.module}/lambda_function.py"
  function_name    = var.function_name
  role             = var.iam_role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("${path.module}/lambda_function.py")
  timeout          = 30
  layers = ["arn:aws:lambda:ap-south-1:380183619747:layer:new:6"]

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
