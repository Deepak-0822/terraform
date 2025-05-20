# variable "secret_name" {
#   type = string
# }

# variable "secret_description" {
#   type = string
# }

# variable "secret_rc_window" {
#   type = string
# }

variable "secret_tags" {
  type = map
  default = {
    "terraform" = "True"
  }
}

variable "secret_values" {
  type      = map(string)
  sensitive = true
  default   = {}
}

variable "rds_instance_identifier" {
  type = map(string)
}

variable "rds_instance_engine" {
  type = string
}

variable "rds_instance_class" {
  type = string
}

variable "rds_instance_allocated_storage" {
  type = string
}

variable "rds_instance_subnet_group" {
  type = string
}

variable "rds_instance_multi_az" {
  type = bool
}

variable "rds_instance_storage_encrypted" {
  type = bool
  default = null
}

variable "rds_instance_kms_key_id" {
  type = string
  default = null
}

variable "rds_instance_db_name" {
  type = map(string)
}

variable "rds_instance_tags" {
  type = map
  default = {
    "terraform" = "True"
  }
}

variable "subnet_group_name" {}
variable "subnet_ids" {
  type = list(string)
}

variable "parameter_group_name" {
  type = string
}

variable "parameter_group_family" {
  type = string
}

# variable "my_db_proxy" {
#   type  = string
# }

variable "rds_secret_id" {
  type  = string
}

# variable "proxy_role_arn" {
#   type        = string
# }


variable "rds_instance_parameter_description" {
  type        = string
}

variable "rds_instance_parameter_group_family" {
  type        = string
}

variable "rds_username" {
  type        = string
  sensitive   = true
}
