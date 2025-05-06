output "id" {
  description = "The ID of the instance"
  value = aws_instance.web[*].id
}