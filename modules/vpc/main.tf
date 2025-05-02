########################################
# Locals
########################################

locals {
  len_public_subnets      = length(var.public_subnets)
  vpc_id                  = try(aws_vpc.this[0].id, "")
  create_public_subnets   = var.create_vpc && local.len_public_subnets > 0
  num_public_route_tables = var.create_multiple_public_route_tables ? local.len_public_subnets : 1
}

########################################
# VPC
########################################

resource "aws_vpc" "this" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = var.cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.vpc_tags
  )
}

########################################
# Public Subnets
########################################

resource "aws_subnet" "public" {
  count = local.create_public_subnets ? local.len_public_subnets : 0

  availability_zone    = element(var.azs, count.index)
  cidr_block           = element(var.public_subnets, count.index)
  vpc_id               = local.vpc_id

  tags = merge(
    {
      Name = try(
        var.public_subnet_names[count.index],
        format("${var.name}-${var.public_subnet_suffix}-%s", element(var.azs, count.index))
      )
    },
    var.tags,
    var.public_subnet_tags,
    lookup(var.public_subnet_tags_per_az, element(var.azs, count.index), {})
  )
}

########################################
# Public Route Tables
########################################

resource "aws_route_table" "public" {
  count  = local.create_public_subnets ? local.num_public_route_tables : 0
  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = var.create_multiple_public_route_tables ?
        format("${var.name}-${var.public_subnet_suffix}-%s", element(var.azs, count.index)) :
        "${var.name}-${var.public_subnet_suffix}"
    },
    var.tags,
    var.public_route_table_tags
  )
}

resource "aws_route_table_association" "public" {
  count = local.create_public_subnets ? local.len_public_subnets : 0

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = var.create_multiple_public_route_tables ?
    aws_route_table.public[count.index].id :
    aws_route_table.public[0].id
}

########################################
# Public Route to Internet Gateway
########################################

resource "aws_route" "public_internet_gateway" {
  count = local.create_public_subnets && var.create_igw ? local.num_public_route_tables : 0

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}
