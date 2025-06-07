locals {
  # Automatically load region-level variables
  account_vars = read_terragrunt_config("${get_terragrunt_dir()}/account.hcl")


  aws_region        = local.account_vars.locals.aws_region
  account_name      = local.account_vars.locals.account_name
  aws_account_id    = local.account_vars.locals.aws_account_id
  prefix            = local.account_vars.locals.prefix
  project_name      = local.account_vars.locals.project_name
  environment_type  = local.account_vars.locals.environment_type
}


remote_state {
  backend = "s3"
  config  = {
    encrypt        = true
    bucket         = "${local.prefix}-${local.project_name}-${local.environment_type}-s3-${local.aws_region}-terraformstate-${local.aws_account_id}"
    key            = "aws/${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile = true
    encrypt = true 
  }
  generate = {
    path      = "backend.gen.tf"
    if_exists = "overwrite_terragrunt"
  }
}

