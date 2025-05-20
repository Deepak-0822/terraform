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
  type = string
}

variable "rds_instance_engine" {
  type = string
}

variable "engine_version" {
    type = string
}
variable "rds_instance_class" {
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
  type = string
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


variable "rds_username" {
  type        = string
  sensitive   = true
}

variable sg_id {
  type = list(string)
}