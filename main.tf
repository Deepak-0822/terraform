module "vpc_aurorards" {
  source = "./modules/vpc"

  name = "${var.environment}-${var.project_name}-vpc-aurorards"
  cidr = var.vpc_cidr
  enable_dns_hostnames       = true
  
  public_subnets  = var.public_subnets
  azs             = var.subnet_azs


  tags = {
    Terraform = "true"
    Environment = "${var.environment}-${var.project_name}"
  }
}

#### Ec2
module "ec2_instance_aurorards" {
  source = "./modules/ec2"

  name = "${var.environment}-${var.project_name}-ec2-aurorards"
  ami  = "ami-0e35ddab05955cf57"
  associate_public_ip_address = true
  instance_type          = var.instance_type
  key_name               = "Test"
  vpc_security_group_ids = [module.sg.sg_id] # Use the output name
  subnet_id              = module.vpc_aurorards.public_subnets[1]  # Access the first (or desired) public subnet ID from the list

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}-${var.project_name}"
  }
}

module "sg" {
  source  = "./modules/security_group"
  vpc_id  = module.vpc_ngnix.vpc_id
}

module "rds_instance" {
  source = "./modules/rds" # Path to your RDS module

  rds_instance_identifier        = "${var.environment}-${var.project_name}-rds-aurora"
  rds_instance_engine            = "aurora-postgresql"
  rds_instance_class             = "db.r5.large"
  rds_instance_allocated_storage = 20
  rds_instance_multi_az          = false
  rds_instance_storage_encrypted = true
  rds_instance_kms_key_id        = var.rds_kms_key_id
  rds_instance_db_name           = "${var.environment}_${var.project_name}_db"

  rds_instance_tags = {
    Environment = var.environment
    Project     = var.project_name
  }

  rds_username           = "admin"
  parameter_group_name   = "${var.environment}-${var.project_name}-aurora-pg"
  parameter_group_family = "aurora-postgresql9.6"

  subnet_group_name = "${var.environment}-${var.project_name}-aurora-subnet-group"
  subnet_ids        = module.vpc.public_subnet_ids

  # Assuming your security group module returns sg ID as `sg_out`
  security_group_module = module.sg.sg_out
}
