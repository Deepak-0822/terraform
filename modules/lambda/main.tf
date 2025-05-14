resource "aws_lambda_function" "container_lambda" {
  function_name = var.lambda_name
  role          = var.role_arn
  package_type  = "Image"
  image_uri     = var.image_uri
  memory_size   = var.memory_size
  timeout       = var.timeout
}
