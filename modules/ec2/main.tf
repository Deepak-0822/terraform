resource "aws_instance" "web" {
  count         = length(var.subnet_ids)
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = length(var.subnet_ids) > 0 ? var.subnet_ids[count.index] : null
  vpc_security_group_ids = length(var.sg_id) > 0 ? var.sg_id : null
  key_name             = var.key_name
  user_data     =  var.user_data

  tags = {
    Name = "${var.name}-web-${count.index + 1}"
  }
}
