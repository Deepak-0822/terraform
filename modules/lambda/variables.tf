variable "lambda_zip_path" {}
variable "function_name" {}
variable "handler" {
  default = "lambda_function.lambda_handler"
}
variable "runtime" {
  default = "python3.9"
}
variable "environment_variables" {
  type    = map(string)
  default = {}
}
variable "role_arn" {}

variable "layer_arn" {
  type = list(string)
}