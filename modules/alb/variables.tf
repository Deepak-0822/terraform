variable "name" {}
variable "internal" {
  type    = bool
  default = false
}
variable "security_groups" {
  type = list(string)
}
variable "subnets" {
  type = list(string)
}
variable "vpc_id" {}
variable "enable_deletion_protection" {
  type    = bool
  default = false
}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "target_group_name" {}
variable "target_group_port" {
  type = number
}

variable "target_group_attachment_port" {
  type = number
}

variable "instance_id" {
  type = list(string)
}
