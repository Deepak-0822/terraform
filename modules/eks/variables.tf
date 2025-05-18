variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "cluster_role_arn" {
  type = string
}

variable "eks_managed_node_groups" {
  description = "EKS managed node groups map"
  type        = map(any)
}

variable "tags" {
  type = map(string)
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "eks_addons" {
  type = map(object({
    addon_version            = optional(string)
    resolve_conflicts        = string
    service_account_role_arn = optional(string)
  }))
  description = "Map of EKS add-ons to deploy"
}
