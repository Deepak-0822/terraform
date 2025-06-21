
include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  prefix            = "hcl"
  project_name      = "bayer"
  environment_type  = "dev"
}

terraform {
  source = "../data-stack/"
}

inputs = {
  prefix            = local.prefix
  project_name      = local.project_name
  environment_type  = local.environment_type
  region            = "us-east-1"
  ecr_repo_name     = "${local.prefix}-${local.project_name}-${local.environment_type}-ecr-repo"
}
