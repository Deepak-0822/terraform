module "vpc" {
  source = "./modules/vpc"

  name = "${var.environment}-${var.project_name}-vpc"
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
module "ec2_instance_image" {
  source = "./modules/ec2"

  name = "${var.environment}-${var.project_name}-ec2-image"
  ami  = "ami-0e35ddab05955cf57"
  associate_public_ip_address = true
  instance_type          = var.instance_type
  key_name               = "ec2-key"
  user_data = file("${path.module}/image_user_data.sh")
  #vpc_security_group_ids = [module.security_group.security_group_id] # Use the output name
  subnet_id              = module.vpc.public_subnets[1]  # Access the first (or desired) public subnet ID from the list

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}-${var.project_name}"
  }
}

module "ec2_instance_register" {
  source = "./modules/ec2"

  name = "${var.environment}-${var.project_name}-ec2-register"
  ami  = "ami-0e35ddab05955cf57"
  associate_public_ip_address = true
  instance_type          = var.instance_type
  key_name               = "ec2-key"
  user_data = file("${path.module}/register_user_data.sh")
  subnet_id              = module.vpc.public_subnets[0]  # Access the first (or desired) public subnet ID from the list

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}-${var.project_name}"
  }
}

module "ec2_instance_default" {
  source = "./modules/ec2"

  name = "${var.environment}-${var.project_name}-ec2-image"
  ami  = "ami-0e35ddab05955cf57"
  associate_public_ip_address = true
  instance_type          = var.instance_type
  key_name               = "ec2-key"
  user_data = file("${path.module}/default_user_data.sh")
  subnet_id              = module.vpc.public_subnets[0]  # Access the first (or desired) public subnet ID from the list

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}-${var.project_name}"
  }
}
### ALB

module "alb" {
  source = "./modules/alb"
 
  name    = "${var.environment}-${var.project_name}-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = [
    module.vpc.public_subnets[0],
    module.vpc.public_subnets[1],
    module.vpc.public_subnets[2]
  ]
 
  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
 
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "10.0.0.0/16"
    }
  }
 
  listeners = {
    default-http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_groups = [
          {
            target_group_key = "image-instance"
            weight           = 33
          },
          {
            target_group_key = "register-instance"
            weight           = 33
          },
          {
            target_group_key = "default-instance"
            weight           = 34
          },
        ]
      }
    }
  }

 
  target_groups = {
    image-instance = {
      name_prefix = "h1"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"
      target_id   =  module.ec2_instance_image.id
    }
    register-instance = {
      name_prefix = "h1"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"
      target_id   =  module.ec2_instance_register.id
    }

    default-instance = {
      name_prefix = "h1"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"
      target_id   =  module.ec2_instance_default.id
    }
  }
 
  tags = {
    Environment = "${var.environment}"
    Project     = "${var.project_name}"
  }
 
  depends_on = [
    module.ec2_instance_image,
    module.ec2_instance_register
  ]
}