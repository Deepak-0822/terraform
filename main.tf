module "vpc" {
  source = "./modules/vpc"

  name = "${var.environment}-${var.project_name}-vpc"
  cidr = var.vpc_cidr
  azs             = var.subnet_azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames       = true
  enable_nat_gateway         = true
  single_nat_gateway         = var.single_nat_gateway
  one_nat_gateway_per_az     = var.one_nat_gateway_per_az #false
  enable_vpn_gateway         = false
  reuse_nat_ips              = true 
  external_nat_ip_ids        = [aws_eip.nat.allocation_id] # <= Directly referencing the allocation_id
  manage_default_network_acl = false

  public_route_table_tags = {
    Name = "${var.environment}-${var.project_name}-pub-igw-rt"
  }
  private_route_table_tags = {
    Name = "${var.environment}-${var.project_name}-pvt-nat-rt"
  }

  igw_tags = {
    Name = "${var.environment}-${var.project_name}-igw"
  }
  nat_gateway_tags = {
    Name = "${var.environment}-${var.project_name}-nat"
  }
  tags = {
    Terraform = "true"
    Environment = "${var.environment}-${var.project_name}"
  }
}

resource "aws_eip" "nat" {
  domain     = "vpc"
  tags       = {
  Name       = "${var.environment}-${var.project_name}-nat-eip"
  }
}

#### Ec2
module "ec2_instance" {
  source  = "./modules/ec2"

  name = "${var.environment}-${var.project_name}-ec2"

  instance_type          = var.instance_type
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = [module.vpc.aws_default_security_group[0]]
  subnet_id              = module.vpc.aws_subnet.public[0].id

  tags = {
    Terraform = "true"
    Environment = "${var.environment}-${var.project_name}"
  }
}