resource "aws_instance" "web" {
  count         = length(var.subnet_ids)
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids[count.index]
  vpc_security_group_ids = [var.sg_id]
  key_name             = var.key_name
  user_data     =  var.user_data

  tags = {
    Name = "${var.name}-web-${count.index + 1}"
  }
}
