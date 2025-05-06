variable "name" {
  description = "Name prefix for ALB resources"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "instance_ids" {
  description = "EC2 instance IDs to register"
  type        = list(string)
}

variable "target_port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
