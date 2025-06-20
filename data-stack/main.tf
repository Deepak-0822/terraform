module "vpc_aurorards" {
  source = "./modules/vpc"

  name = "${local.prefix}-${local.project_name}-${local.environment_type}-vpc"
  cidr = var.vpc_cidr
  enable_dns_hostnames       = true
  
  public_subnets  = var.public_subnets
  azs             = var.subnet_azs


  tags = {
    Terraform = "true"
    Environment = "${local.prefix}-${local.project_name}-${local.environment_type}"
  }
}
