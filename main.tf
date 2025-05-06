## VPC
module "vpc" {
  source              = "./modules/vpc"

  name = "${var.environment}-${var.project_name}-vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnets
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
  name           = "${var.environment}-${var.project_name}-openproject"
  ami_id         = "ami-0e35ddab05955cf57"
  instance_type  = var.instance_type
  key_name       = "ec2-key"
  subnet_ids     = module.vpc.public_subnet_ids
  sg_id          = module.sg.web_sg_id
  user_data = file("${path.module}/user_data.sh")
}

module "alb" {
  source                   = "./modules/alb"
  name                     = "openproject-alb"
  internal                 = false
  security_groups          = [module.sg.web_sg_id] 
  subnets                  = module.vpc.public_subnet_ids
  vpc_id                   = module.vpc.vpc_id
  target_id            = [module.ec2.id]
  enable_deletion_protection = false

  tags = {
    Environment = "dev"
    App         = "openproject"
  }
  target_group_name = "openproject-tg"
  target_group_port = 8080
}
