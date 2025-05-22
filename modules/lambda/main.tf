resource "aws_lambda_function" "this" {
  filename         = var.lambda_zip_path
  function_name    = var.function_name
  role          = var.role_arn
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = filebase64sha256(var.lambda_zip_path)
  timeout          = 60
  layers     = var.layer_arn

  environment {
    variables = var.environment_variables
  }
}