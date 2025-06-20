module "vpc" {
  source = "./modules/vpc"

  name = "${var.prefix}-${var.project_name}-${var.environment_type}-vpc"
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.subnet_azs
  public_subnet_cidrs  = var.public_subnets
  private_subnet_cidrs = var.private_subnets
  enable_dns_hostnames = true
  tags = {
    Environment = "${var.prefix}-${var.project_name}-${var.environment_type}"
  }
}
