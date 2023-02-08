// Networking stack
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.identifier
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.identifier}-igw"
  }
}

resource "aws_eip" "eip" {
  vpc = true
  tags = {
    Name = "${var.identifier}-eip"
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.identifier}-public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnet_cidrs)
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.identifier}-private-${count.index}"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on = [
    aws_internet_gateway.igw
  ]
  tags = {
    Name = "${var.identifier}-nat"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "public-rt-${var.identifier}"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "private-rt-${var.identifier}}"
  }
}

resource "aws_route" "public_routes" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "private_routes" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public_route_association" {
  route_table_id = aws_route_table.public_rt.id
  count          = length(aws_subnet.public)
  subnet_id      = element(aws_subnet.public.*.id, 0)
}

resource "aws_route_table_association" "private_route_association" {
  route_table_id = aws_route_table.private_rt.id
  count          = length(aws_subnet.private)
  subnet_id      = element(aws_subnet.private.*.id, 0)
}
