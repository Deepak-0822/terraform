variable "cluster_name" {
  description = "ECS Cluster Name"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM Role ARN for ECS execution"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for ECS tasks"
  type        = list(string)
}

variable "sg_id" {
  description = "Security group for ECS tasks"
  type        = string
}

variable "alb_target_group_arn" {
  description = "ALB Target Group ARN"
  type        = string
}

variable "services" {
  description = "Map of ECS services with image and port"
  type = map(object({
    image           = string
    container_port = number
  }))
}