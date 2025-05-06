resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-public-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

locals {
  create_private_subnets = length(try(var.private_subnet_cidrs, [])) > 0 && local.create_vpc
  create_vpc = var.create_vpc
}

resource "aws_subnet" "private" {
  count             = local.create_private_subnets ? length(var.private_subnet_cidrs) : 0
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.name}-private-${count.index + 1}"
  }
}

resource "aws_route_table" "private" {
  count    = local.create_private_subnets ? 1 : 0
  vpc_id   = aws_vpc.this.id
  tags = {
    Name = "${var.name}-private-rt"
  }
}

resource "aws_route" "private_nat" {
  count                     = local.create_private_subnets && length(try(aws_nat_gateway.this, [])) > 0 ? 1 : 0
  route_table_id            = aws_route_table.private[0].id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.this[0].id
  depends_on = [
    aws_route_table.private,
    aws_nat_gateway.this,
  ]
}

resource "aws_route_table_association" "private" {
  count          = local.create_private_subnets ? length(var.private_subnet_cidrs) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}

resource "aws_eip" "this" {
  count    = local.create_public_subnets ? 1 : 0
  domain   = "vpc"
  tags = {
    Name = "${var.name}-eip-nat" # Added a tag for clarity
  }
}

resource "aws_nat_gateway" "this" {
  count         = local.create_public_subnets ? 1 : 0
  allocation_id = aws_eip.this[0].id
  subnet_id     = length(aws_subnet.public) > 0 ? aws_subnet.public[0].id : null
  tags = {
    Name = "${var.name}-nat"
  }
  depends_on = [aws_eip.this, aws_subnet.public]
}