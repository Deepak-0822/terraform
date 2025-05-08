test "basic" {
  description = "Check if S3 bucket name matches input"
 
  variables = {
    name = "test-s3-bucket-123"
  }
 
  asserts {
    output "bucket_name" {
      equals = "test-s3-bucket-123"
    }
 
    resource "aws_s3_bucket.this" {
      values = {
        bucket = "test-s3-bucket-123"
      }
    }
  }
}