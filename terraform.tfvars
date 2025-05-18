#   aws_region                     = ap-south-1
project_name                   = "hcl"
environment                    = "dev"
vpc_cidr                       = "10.4.0.0/16"
subnet_azs                     = ["ap-south-1a", "ap-south-1b"]
public_subnets                 = ["10.4.3.0/24", "10.4.4.0/24"]
private_subnets                = ["10.4.1.0/24", "10.4.2.0/24"]
single_nat_gateway             = true
one_nat_gateway_per_az         = false
db_instance_type               = "db.t3.micro"
db_password                    = "admin123"

ami_id             = "ami-0e35ddab05955cf57"
instance_type      = "t2.micro"
subnet_id          = "subnet-0fbb3fc18e4c94bc5"
security_group_ids = ["sg-01ef8f8570f46a7f2"]
key_name           = "Test"
instance_name      = "my-ec2-instance"
