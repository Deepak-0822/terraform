variable "lambda_zip_path" {}
variable "function_name" {}
variable "handler" {
  default = "lambda_function.lambda_handler"
}
variable "runtime" {
  default = "python3.8"
}
variable "environment_variables" {
  type    = map(string)
  default = {}
}
variable "role_arn" {}