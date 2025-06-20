vpc_cidr                       = "10.4.0.0/16"
subnet_azs                     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
public_subnets                 = ["10.4.3.0/24", "10.4.4.0/24", "10.4.5.0/24" ]
single_nat_gateway             = true
one_nat_gateway_per_az         = false