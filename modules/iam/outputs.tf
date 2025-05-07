output "lambda_role_arn" {
  description = "The ID of the instance"
  value = aws_iam_role.lambda_exec.arn
}