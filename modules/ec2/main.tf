locals {
  create = var.create == null ? 1 : 0

  is_t_instance_type = replace(var.instance_type, "/^t(2|3|3a|4g){1}\\..*$/", "1") == "1" ? true : false
}


################################################################################
# Instance
################################################################################

resource "aws_instance" "this" {
  count = local.create

  ami                  = var.ami
  instance_type        = var.instance_type
  cpu_core_count       = var.cpu_core_count

  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  availability_zone      = var.availability_zone
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  key_name             = var.key_name

  associate_public_ip_address = var.associate_public_ip_address


  ebs_optimized = var.ebs_optimized


  tags        = merge({ "Name" = var.name }, var.instance_tags, var.tags)
  volume_tags = var.enable_volume_tags ? merge({ "Name" = var.name }, var.volume_tags) : null
}