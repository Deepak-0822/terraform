output "id" {
  description = "The ID of the instance"
  value = try(aws_instance.this[0].id,  null)
}
