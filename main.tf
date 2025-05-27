module "cloudtrail_monitoring" {
  source                 = "./modules/cloudtrail_monitoring"
  sns_arn                = [module.sns.topic_arn]  
  cloudtrail_s3_bucket   = module.cloudtrail_s3.bucket_name
  log_group_name         = var.log_group_name
}

module "sns" {
  source        = "./modules/sns"
  topic_name    = "cloudtrail-sns-topic"
  email_address = "dee@hcltech.com"
}


data "aws_caller_identity" "current" {}

module "cloudtrail_s3" {
  source      = "./modules/s3"
  bucket_name = "cloudtrail-log-bucket-123"
  account_id  = data.aws_caller_identity.current.account_id
}
