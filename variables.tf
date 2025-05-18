variable "environment" {
  type    = string
}

variable "project_name" {
  description = "The CIDR of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR of the VPC"
  type        = string
  default     = null
}

variable "subnet_azs" {
  description = "The list of azs where the subnets should be located"
  type        = list(string)
  default     = null
}

variable "private_subnets" {
  description = "The list of private subnets CIDRs."
  type        = list(string)
  default     = null
}

variable "public_subnets" {
  description = "The list of public subnets CIDRs."
  type        = list(string)
  default     = null
}

variable "single_nat_gateway" {
  description = "The meantion single az true or false."
  type        = bool
  default     = null
}

variable "one_nat_gateway_per_az" {
  description = "The meantioning per az per nat."
  type        = bool
  default     = null
}




