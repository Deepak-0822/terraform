resource "aws_secretsmanager_secret" "rds_secret" {
 name = "aurora-secret"
}
 
resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = var.rds_username
    password = random_password.rds_password.result
  })
 
  depends_on = [aws_secretsmanager_secret.rds_secret]
}
 
resource "random_password" "rds_password" {
  length  = 16
  special = true
}
 
resource "aws_db_instance" "my_rds_instance" {
  identifier                = var.rds_instance_identifier
  engine                    = var.rds_instance_engine
  instance_class            = var.rds_instance_class
  db_subnet_group_name      = aws_db_subnet_group.generic_subnet_group.name
  vpc_security_group_ids    = var.sg_id
  multi_az                  = var.rds_instance_multi_az
  storage_encrypted         = var.rds_instance_storage_encrypted
  kms_key_id                = var.rds_instance_kms_key_id
  db_name                   = var.rds_instance_db_name
  parameter_group_name      = var.parameter_group_name
  tags                      = var.rds_instance_tags
  copy_tags_to_snapshot     = true
 
  username                  = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)["username"]
  password                  = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)["password"]
 
  depends_on = [aws_db_subnet_group.generic_subnet_group, aws_secretsmanager_secret_version.rds_secret_version]
}
 
resource "aws_db_parameter_group" "generic_pg_param_group" {
  name   = var.parameter_group_name
  family = var.parameter_group_family
  tags   = var.rds_instance_tags
}
 
resource "aws_db_subnet_group" "generic_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
  tags       = var.rds_instance_tags
}
