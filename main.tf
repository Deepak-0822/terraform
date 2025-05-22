module "iam_lambda" {
  source         = "./modules/iam"
  lambda_role_name = var.lambda_role_name
}

module "lambda_hello" {
  source               = "./modules/lambda"
  function_name        = "lambda_hello"
  lambda_zip_path      = "./lambda_function.zip"
  role_arn             = module.iam_lambda.role_arn
}

module "cognito" {
  source                = "./modules/cognito"
  user_pool_name        = "hello_user_pool"
  app_client_name       = "hello_app_client"
  domain_prefix         = var.cognito_domain_prefix
  api_id          = module.api_gateway.api_id
  aws_region      = "ap-south-1"

}

module "api_gateway" {
  source                     = "./modules/apigateway"
  lambda_function_arn        = module.lambda_hello.lambda_function_arn
  cognito_user_pool_client_id = module.cognito.client_id
  cognito_user_pool_domain    = var.cognito_domain_prefix
  aws_region                 = "ap-south-1"
}