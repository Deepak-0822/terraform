output "web_sg_id" {
  description = "Security Group ID for the Web Servers"
  value       = aws_security_group.web_sg.id
}

output "rds_sg_id" {
  description = "Security Group ID for the RDS Instance"
  value       = aws_security_group.rds_sg.id
}
