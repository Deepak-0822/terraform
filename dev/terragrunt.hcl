
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
  vpc_cidr          = "10.0.0.0/16"                  # example; override if needed
  subnet_azs        = ["ap-south-1a", "ap-south-1b"]
  public_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets                = ["10.0.3.0/24", "10.0.4.0/24"]
  single_nat_gateway             = true
  one_nat_gateway_per_az         = false
}
