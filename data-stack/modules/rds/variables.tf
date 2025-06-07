variable "name" {}
variable "subnet_ids" {
  type = list(string)
}
variable "instance_type" {}
variable "db_user" {}
variable "db_password" {}
variable "db_name" {}
variable "sg_id" {}
