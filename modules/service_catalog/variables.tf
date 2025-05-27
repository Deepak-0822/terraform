variable "portfolio_name" {}
variable "portfolio_description" {}
variable "provider_name" {}
variable "product_name" {}
variable "owner" {}
variable "artifact_name" {}
variable "template_url" {}
variable "launch_role_arn" {}
variable "user_arn" {}
variable "tag_key" {
  default = "env"
}
variable "tag_value" {
  default = "dev"
}
