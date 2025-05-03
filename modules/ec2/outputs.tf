output "id" {
  description = "The ID of the instance"
  value = try(
    aws_instance.this[0].id,
    aws_instance.ignore_ami[0].id,
    aws_spot_instance_request.this[0].id,
    null,
  )
}