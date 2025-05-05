## VPC
module "vpc" {
  source              = "./modules/vpc"

  name = "${var.environment}-${var.project_name}-vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnets
  private_subnet_cidrs = var.private_subnets
  availability_zones  = var.subnet_azs

}


## sg
module "sg" {
  source = "./modules/security_group"
  name   = "${var.environment}-${var.project_name}-sg"
  vpc_id = module.vpc.vpc_id
}

## Ec2

module "ec2" {
  source         = "./modules/ec2"
  name           = "${var.environment}-${var.project_name}-ec2"
  ami_id         = "ami-0e35ddab05955cf57"
  instance_type  = var.instance_type
  key_name               = "ec2-key"
  subnet_ids     = module.vpc.public_subnet_ids
  sg_id          = module.sg.web_sg_id
  user_data = file("${path.module}/user_data.sh")
}

module "rds" {
  source         = "./modules/rds"
  name           = "${var.environment}-${var.project_name}-rds"
  instance_type  = var.db_instance_type
  db_user        = "admin"
  db_password    = var.db_password
  db_name        = "myappdb"
  subnet_ids     = module.vpc.private_subnet_ids
  sg_id          = module.sg.rds_sg_id
}