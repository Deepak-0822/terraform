module "lambda_hello" {
  source               = "./modules/lambda"
  function_name        = "lambda_hello"
  lambda_zip_path      = "./lambda_function.zip"
}

