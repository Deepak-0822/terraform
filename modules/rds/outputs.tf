output "secret_arn" {
  value = aws_secretsmanager_secret.rds_secret.arn #module.secrets.secret_arn
}

output "secret_values" {
  value = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string) #module.secrets.secret_values
  sensitive   = true
}
