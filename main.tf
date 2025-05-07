module "s3" {
  source         = "./modules/s3"
  bucket_name    = var.bucket_name
}

module "sns" {
  source         = "./modules/sns"
  topic_name     = var.topic_name
}

module "lambda" {
  source            = "./modules/lambda"
  lambda_name       = var.lambda_name
  bucket_name       = module.s3.bucket_name
  sns_topic_arn     = module.sns.topic_arn
  s3_notification_id = "image-upload"
}
