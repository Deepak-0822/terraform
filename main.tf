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
  source = "./modules/rds" # Assuming your module is in a subdirectory named "modules/rds"

  rds_instance_identifier      = "${var.environment}-${var.project_name}-rds-aurora"
  rds_instance_engine          = "aurora-postgresql"
  rds_instance_class           = "db.r5.large"
  rds_instance_allocated_storage = 20
  rds_instance_multi_az        = false
  rds_instance_db_name         = ${var.environment}-${var.project_name}-rds-aurora-instance"
  rds_instance_tags = {
    Environment = "dev"
    Project     = "my-app"
  }

  rds_username           = "admin"
  parameter_group_name   = "${var.environment}-${var.project_name}-rds-auror"
  parameter_group_family = "aurora-postgresql9.6" # Adjust based on your engine version

  subnet_group_name = "${var.environment}-${var.project_name}-rds-auror-subnet-group"
  subnet_ids        = [module.vpc.public_subnet_ids] # Replace with your subnet IDs

  # Assuming your security group module outputs the ID in a variable named 'sg_out'
  security_group_module = module.sg.sg_id
}