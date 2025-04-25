module "vpc" {
  source = "./modules/vpc"

  name = "${var.environment}-${var.project_name}-vpc"
  cidr = var.vpc_cidr
  azs             = var.subnet_azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway = false
  reuse_nat_ips       = true 
  # external_nat_ip_ids = [data.aws_eip.by_allocation_id.id]   # <= IPs specified here as input to the module
  external_nat_ip_ids = [aws_eip.nat.allocation_id] # <= Directly referencing the allocation_id
  manage_default_network_acl = false

  igw_tags = {
    Name = "${var.environment}-${var.project_name}-igw"
  }
  public_route_table_tags = {
    Name = "${var.environment}-${var.project_name}-pub-igw-rt"
  }
  private_route_table_tags = {
    Name = "${var.environment}-${var.project_name}-pvt-nat-rt"
  }

  tags = {
    Terraform = "true"
    Environment = "${var.environment}"
  }
}

resource "aws_eip" "nat" {
  domain   = "vpc"
  tags = {
    Environment = "${var.environment}-nat-eip"
  }
}