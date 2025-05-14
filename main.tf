module "iam_lambda" {
  source         = "./modules/iam"
  lambda_role_name = var.lambda_role_name
}

module "lambda_container" {
  source               = "./modules/lambda"
  lambda_name          = var.lambda_name
  image_uri            = var.image_uri
  role_arn             = module.iam_lambda.role_arn
  memory_size          = var.memory_size
  timeout              = var.timeout
}

module "api_gateway" {
  source               = "./modules/apigateway"
  lambda_function_name = module.lambda_container.lambda_name
  region               = "ap-south-1"
}
