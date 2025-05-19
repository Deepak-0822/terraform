module "vpc_ngnix" {
  source = "./modules/vpc"

  name = "${var.environment}-${var.project_name}-vpc-ngnix"
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
module "ec2_instance_ngnix" {
  source = "./modules/ec2"

  name = "${var.environment}-${var.project_name}-ec2-ngnix"
  ami  = "ami-0e35ddab05955cf57"
  associate_public_ip_address = true
  instance_type          = var.instance_type
  key_name               = "Test"
  user_data = file("${path.module}/ngnix_data.sh")
  vpc_security_group_ids = [module.sg.sg_id] # Use the output name
  subnet_id              = module.vpc_ngnix.public_subnets[1]  # Access the first (or desired) public subnet ID from the list

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}-${var.project_name}"
  }
}

module "sg" {
  source  = "./modules/security_group"
  vpc_id  = module.vpc_ngnix.vpc_id
}