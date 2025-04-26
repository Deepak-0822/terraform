# modules/vpc/outputs.tf

output "default_security_group_id" {
  description = "The ID of the default security group created by the VPC module."
  value       = aws_default_security_group.default[0].id # Assuming you named your default SG 'default' and might have one
}

output "public_subnet_ids" {
  description = "A list of IDs of the public subnets."
  value       = [for subnet in aws_subnet.public : subnet.id] # Assuming you named your public subnets 'public'
}