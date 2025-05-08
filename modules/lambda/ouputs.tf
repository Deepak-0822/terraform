output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "invoke_arn" {
  description = "The invoke ARN of the lambda"
  value       = aws_lambda_function.this.invoke_arn
}

output "qualified_arn" {
  description = "The qualified ARN of the lambda function"
  value       = aws_lambda_function.this.qualified_arn
}