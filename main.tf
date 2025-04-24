### vpc creation 

resource "aws_vpc" "dev_vpc" {
  cidr_block       =  var.dev-vpc-cidr ## Hosts/Net total ip's: 65534
  instance_tenancy = "default"

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "dev_1apub_subnet" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = var.dev-1apub-subnet-cidr  ## total ip's 254 
  availability_zone = "ap-south-1a"

  tags = {
    Name = "dev-1apub-subnet"
  }
}

resource "aws_subnet" "dev_1bpub_subnet" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = var.dev-1bpub-subnet-cidr   
  availability_zone = "ap-south-1b"

  tags = {
    Name = "dev-1bpub-subnet"
  }
}

resource "aws_subnet" "dev_1apvt_subnet" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = var.dev-1apvt-subnet-cidr   ## total ip's 254 
  availability_zone = "ap-south-1a"

  tags = {
    Name = "dev-1apvt-subnet"
  }
}

resource "aws_subnet" "dev_1bpvt_subnet" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = var.dev-1bpvt-subnet-cidr   ## total ip's 254 
  availability_zone = "ap-south-1b"

  tags = {
    Name = "dev-1bpvt-subnet"
  }
}

resource "aws_internet_gateway" "igw_public_subnet" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "igw_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_public_subnet.id
  }

  tags = {
    Name = "igw_route_table"
  }
}

resource "aws_route_table_association" "pub_subnet_association_1" {
  subnet_id      = aws_subnet.dev_1apub_subnet.id
  route_table_id = aws_route_table.igw_route_table.id
}

resource "aws_route_table_association" "pub_subnet_association_2" {
  subnet_id      = aws_subnet.dev_1bpub_subnet.id
  route_table_id = aws_route_table.igw_route_table.id
}

resource "aws_nat_gateway" "nat_pvt_subnet" {
  connectivity_type                  = "public"
  subnet_id                          = aws_subnet.dev_1apub_subnet.id
    tags = {
    Name = "nat"
  }
}

resource "aws_route_table" "nat_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_pvt_subnet.id
  }

  tags = {
    Name = "nat_route_table"
  }
}

resource "aws_route_table_association" "pvt_subnet_association_1" {
  subnet_id      = aws_subnet.dev_1apvt_subnet.id
  route_table_id = aws_route_table.nat_route_table.id
}

resource "aws_route_table_association" "pvt_subnet_association_2" {
  subnet_id      = aws_subnet.dev_1bpvt_subnet.id
  route_table_id = aws_route_table.nat_route_table.id
}


#terraform {
 # backend "s3" {}
#}