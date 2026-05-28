# TODO: Implement the VPC module resources below.
#
# Required resources:
#
#   aws_vpc (name: "main")
#     - Use var.vpc_cidr for the CIDR block
#     - Enable DNS hostnames and DNS support

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.name}-vpc"
  })
}

#
#   aws_internet_gateway (name: "main")
#     - Attach to the VPC

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.name}-igw"
  })
}

#
#   aws_subnet (name: "public", one per AZ)
#     - Use count or for_each to create one subnet per item in var.availability_zones
#     - CIDRs come from var.public_subnet_cidrs
#     - Enable auto-assign public IP

resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name}-public-${var.availability_zones[count.index]}"
  })
}

#
#   aws_subnet (name: "private", one per AZ)
#     - Mirror the public subnets using var.private_subnet_cidrs
#     - Do NOT auto-assign public IPs
#

resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.name}-private-${var.availability_zones[count.index]}"
  })
}

#   aws_route_table (name: "public")
#     - Add a route for 0.0.0.0/0 pointing to the Internet Gateway

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = "${var.name}-public-rt"
  })
}

#
#   aws_route_table_association (name: "public", one per public subnet)

resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#
#   aws_eip (name: "nat")
#     - Only create when var.enable_nat_gateway is true (use count)

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name}-nat-eip"
  })
}

#
#   aws_nat_gateway (name: "main")
#     - Only create when var.enable_nat_gateway is true (use count)
#     - Place in the first public subnet
#     - Depends on the EIP

resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.tags, {
    Name = "${var.name}-nat-gw"
  })

  depends_on = [aws_eip.nat, aws_internet_gateway.main]
}

#
#   aws_route_table (name: "private")
#     - Add a route for 0.0.0.0/0 pointing to the NAT Gateway (when enabled)

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main[0].id
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name}-private-rt"
  })
}

#
#   aws_route_table_association (name: "private", one per private subnet)

resource "aws_route_table_association" "private" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

#
#   aws_security_group (name: "default")
#     - Sensible ingress/egress rules for the environment

resource "aws_security_group" "default" {
  name        = "${var.name}-default-sg"
  description = "Default security group for ${var.name}"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr] # VPC-internal only
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-default-sg"
  })
}

#
# Hints:
#   - Use merge(var.tags, { Name = "..." }) on all resources for consistent tagging
#   - Use var.name as a prefix on all Name tags
#   - The NAT Gateway must be in a public subnet and requires the Internet Gateway to exist first
