output "bucket_name" {
  value = aws_s3_bucket.cloudtrail.id
}

output "bucket_arn" {
  value = aws_s3_bucket.cloudtrail.arn
}
