module "service_catalog" {
  source                = "./modules/service_catalog"
  portfolio_name        = "S3 Portfolio"
  portfolio_description = "Portfolio for provisioning S3 buckets"
  provider_name         = "test"

  product_name   = "S3 Bucket Product"
  owner          = "service_catalog_test"
  artifact_name  = "v1"
  template_url   = "https://cloudtrail-log-bucket-1234.s3.ap-south-1.amazonaws.com/test.yaml"
  launch_role_arn = "arn:aws:iam::971422676158:role/service-catalog-role"
  user_arn       = "arn:aws:iam::971422676158:user/service_catlog"

  tag_key   = "env"
  tag_value = "dev"
}

