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

module "ec2_openproject" {
  source         = "./modules/ec2"
  name           = "${var.environment}-${var.project_name}-openproject"
  ami_id         = "ami-0e35ddab05955cf57"
  instance_type  = var.instance_type
  key_name       =  "ec2-key"
  subnet_ids     = [module.vpc.public_subnet_ids[0]]  # Deploy in one AZ only
  sg_id          = module.sg.web_sg_id
  user_data      = file("${path.module}/user_data_openproject.sh")
}

module "ec2_devlake" {
  source         = "./modules/ec2"
  name           = "${var.environment}-${var.project_name}-docker"
  ami_id         = "ami-0e35ddab05955cf57"
  instance_type  = var.instance_type
  key_name       =  "ec2-key"
  subnet_ids     = [module.vpc.public_subnet_ids[1]]  # next 2 AZs
  sg_id          = module.sg.web_sg_id
  user_data      = file("${path.module}/user_data_devlake.sh")
}

### alb
# ALB for OpenProject - port 80
module "alb_openproject" {
  source                   = "./modules/alb"
  name                     = "openproject-alb"
  internal                 = false
  security_groups          = [module.sg.web_sg_id]
  subnets                  = module.vpc.public_subnet_ids
  vpc_id                   = module.vpc.vpc_id
  instance_id = module.ec2_openproject.id
  enable_deletion_protection = false

  tags = {
    Environment = var.environment
    App         = "openproject"
  }

  target_group_name = "openproject-tg"
  target_group_port = 80
  target_group_attachment_port = 80
}

# ALB for DevLake - port 4000
module "alb_devlake" {
  source                   = "./modules/alb"
  name                     = "devlake-alb"
  internal                 = false
  security_groups          = [module.sg.web_sg_id]
  subnets                  = module.vpc.public_subnet_ids
  vpc_id                   = module.vpc.vpc_id
  instance_id = module.ec2_devlake.id  # List of 2 instance IDs
  enable_deletion_protection = false

  tags = {
    Environment = var.environment
    App         = "devlake"
  }

  target_group_name = "devlake-tg"
  target_group_port = 4000
  target_group_attachment_port = 4000
}









