resource "aws_vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags             = local.common_tags
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary" {
  vpc_id     = aws_vpc.example.id
  cidr_block = var.secondary_cidr
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
  tags   = local.common_tags
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id     = aws_vpc.example.id
  cidr_block = element(var.public_subnets, count.index)
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, { "Name" = "public-subnet-${count.index}" })
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id     = aws_vpc.example.id
  cidr_block = element(var.private_subnets, count.index)
  map_public_ip_on_launch = false
  tags = merge(local.common_tags, { "Name" = "private-subnet-${count.index}" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
  tags   = local.common_tags
}

resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}