### vpc
variable "vpc_cidr" {
  description = "The CIDR of the VPC"
  type        = string
}

variable "subnet_azs" {
  description = "The list of azs where the subnets should be located"
  type        = list(string)
}


variable "private_subnets" {
  description = "The list of private subnets CIDRs."
  type        = list(string)
}

variable "public_subnets" {
  description = "The list of public subnets CIDRs."
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "The meantion single az true or false."
  type        = bool
}

variable "one_nat_gateway_per_az" {
  description = "The meantioning per az per nat."
  type        = bool
}

variable "prefix" {}
variable "project_name" {}
variable "environment_type" {}