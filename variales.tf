
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

## ec2


variable "user_data" {
  type    = string
  default = ""
}


variable "db_instance_type" {
  description = "The CIDR of the VPC"
  type        = string
  default     = null
}

variable "db_password" {
  description = "The CIDR of the VPC"
  type        = string
  default     = null
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}
variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "security_group_ids" {
  type = list(string)
}
variable "key_name" {}
variable "instance_name" {}


variable "ec2-instance" {
  type        = string
  default     = "i-0d267d2f811fba8aa"
}