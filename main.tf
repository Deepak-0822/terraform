module "iam" {
  source = "./modules/iam"
  name   = "image-processor-role"
}

module "sns" {
  source        = "./modules/sns"
  topic_name    = "image-process-topic"
  email_address = "notify@example.com"
}

module "lambda" {
  source             = "./modules/lambda"
  function_name      = "image-resizer"
  iam_role_arn       = module.iam.lambda_role_arn
  dest_bucket        = module.dest_bucket.bucket_name
  sns_topic_arn      = module.sns.topic_arn
  source_bucket_arn  = module.source_bucket.bucket_arn
}

module "source_bucket" {
  source           = "./modules/s3"
  name             = "image-source-bucket-123"
  lambda_arn       = module.lambda.lambda_arn
  lambda_permission = module.lambda.lambda_permission
  prefix           = "uploads/"
}

module "dest_bucket" {
  source = "./modules/s3"
  name   = "image-destination-bucket-123"
  lambda_arn       = module.lambda.lambda_arn
  lambda_permission = module.lambda.lambda_permission
}

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = module.source_bucket.bucket_name

  lambda_function {
    lambda_function_arn = module.lambda.lambda_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [module.lambda] # Wait until lambda + permission are ready
}