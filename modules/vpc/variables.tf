variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = null # Set the default to null
}

variable "availability_zones" {
  description = "List of AZs to use"
  type        = list(string)
}
