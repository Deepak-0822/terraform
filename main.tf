module "iam_lambda" {
  source         = "./modules/iam"
  lambda_role_name = "claude-sonnet-role"
}

module "lambda_container" {
  source               = "./modules/lambda"
  function_name        = "claude-sonnet" 
  lambda_zip_path      = "./lambda_function.zip"
  role_arn             = module.iam_lambda.role_arn
  layer_arn            = ["arn:aws:lambda:ap-south-1:971422676158:layer:fitzz-layer:2", "arn:aws:lambda:ap-south-1:971422676158:layer:puf-layer:1"]
}

module "api_gateway" {
  source               = "./modules/apigateway"
  lambda_function_name = module.lambda_container.lambda_name
  region               = "ap-south-1"
}