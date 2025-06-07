resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "this" {
  identifier             = "${var.name}-rds"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.instance_type
  username               = var.db_user
  password               = var.db_password
  db_name                = var.db_name
  vpc_security_group_ids = [var.sg_id]
  db_subnet_group_name   = aws_db_subnet_group.this.name
  skip_final_snapshot    = true
}
