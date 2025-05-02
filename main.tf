module "vpc" {
  source = "./modules/vpc"

  name = "${var.environment}-${var.project_name}-vpc"
  cidr = var.vpc_cidr

  enable_dns_hostnames       = true

  tags = {
    Terraform = "true"
    Environment = "${var.environment}-${var.project_name}"
  }
}

module "vpc2" {
  source = "./modules/vpc"

  name = "${var.environment}-${var.project_name}-vpc2"
  cidr = 10.2.2.2/23

  enable_dns_hostnames       = true

  tags = {
    Terraform = "true"
    Environment = "${var.environment}-${var.project_name}"
  }
}