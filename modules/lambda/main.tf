resource "aws_lambda_function" "this" {
  filename         = var.lambda_zip_path
  function_name    = var.function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = filebase64sha256(var.lambda_zip_path)
  timeout          = 60

  environment {
    variables = var.environment_variables
  }
}