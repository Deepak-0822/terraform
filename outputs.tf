output "source_bucket_name" {
  value = module.source_bucket.bucket_name
}

output "destination_bucket_name" {
  value = module.dest_bucket.bucket_name
}

output "lambda_function_arn" {
  value = module.lambda.lambda_arn
}

output "sns_topic_arn" {
  value = module.sns.topic_arn
}

output "iam_role_arn" {
  value = module.iam.lambda_role_arn
}
