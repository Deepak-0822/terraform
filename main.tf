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

