## VPC
module "vpc" {
  source              = "./modules/vpc"

  name = "${var.environment}-${var.project_name}-vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnets
  availability_zones  = var.subnet_azs

}

module "sg" {
  source  = "./modules/security_group"
  vpc_id  = module.vpc.vpc_id
}

module "alb" {
  source     = "./modules/alb"
  name       = "ecs-alb"
  subnet_ids = module.vpc.public_subnet_ids
  vpc_id     = module.vpc.vpc_id
  sg_id      = module.sg.sg_id
}

module "iam" {
  source = "./modules/iam"
  role_name = "${var.environment}-${var.project_name}-ecs-iam"
}

module "ecs_stack" {
  source             = "./modules/ecs"
  cluster_name       = "${var.environment}-${var.project_name}-ecs"
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  subnet_ids         = module.vpc.public_subnet_ids
  sg_id              = module.sg.sg_id

  alb_target_group_arns = {
    patient     = module.alb.patients_tg_arn
    appointment = module.alb.appointments_tg_arn
  }

  services = {
    patient = {
      image          = "971422676158.dkr.ecr.ap-south-1.amazonaws.com/patient-service:v3"
      container_port = 80
    }
    appointment = {
      image          = "971422676158.dkr.ecr.ap-south-1.amazonaws.com/appointment-service:v4"
      container_port = 80
    }
  }
}
