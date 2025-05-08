##ec2

module "ec2" {
  source         = "./modules/ec2"
  name           = "${var.environment}-${var.project_name}-ec2"
  ami_id         = "ami-0e35ddab05955cf57"
  instance_type  = var.instance_type
  key_name               = "ec2-key"
}
module "lambda_start" {
  source               = "./modules/lambda"
  function_name        = "start-instance"
  lambda_zip_path      = "./lambda_start.zip"
  environment_variables = length(module.ec2.id) > 0 ? { INSTANCE_ID = module.ec2.id[0] } : {}
}

module "lambda_stop" {
  source               = "./modules/lambda"
  function_name        = "stop-instance"
  lambda_zip_path      = "./lambda_stop.zip"
  environment_variables = length(module.ec2.id) > 0 ? { INSTANCE_ID = module.ec2.id[0] } : {}

}

module "cloudwatch_start" {
  source     = "./modules/cloudwatch_event"
  rule_name  = "start-schedule"
  schedule   = "cron(0 8 ? * MON-FRI *)"
  lambda_arn = module.lambda_start.lambda_arn
}

module "cloudwatch_stop" {
  source     = "./modules/cloudwatch_event"
  rule_name  = "stop-schedule"
  schedule   = "cron(0 17 ? * MON-FRI *)"
  lambda_arn = module.lambda_stop.lambda_arn
}
