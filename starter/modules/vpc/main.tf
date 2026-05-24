# TODO: Implement the VPC module resources below.
#
# Required resources:
#
#   aws_vpc (name: "main")
#     - Use var.vpc_cidr for the CIDR block
#     - Enable DNS hostnames and DNS support
#
#   aws_internet_gateway (name: "main")
#     - Attach to the VPC
#
#   aws_subnet (name: "public", one per AZ)
#     - Use count or for_each to create one subnet per item in var.availability_zones
#     - CIDRs come from var.public_subnet_cidrs
#     - Enable auto-assign public IP
#
#   aws_subnet (name: "private", one per AZ)
#     - Mirror the public subnets using var.private_subnet_cidrs
#     - Do NOT auto-assign public IPs
#
#   aws_route_table (name: "public")
#     - Add a route for 0.0.0.0/0 pointing to the Internet Gateway
#
#   aws_route_table_association (name: "public", one per public subnet)
#
#   aws_eip (name: "nat")
#     - Only create when var.enable_nat_gateway is true (use count)
#
#   aws_nat_gateway (name: "main")
#     - Only create when var.enable_nat_gateway is true (use count)
#     - Place in the first public subnet
#     - Depends on the EIP
#
#   aws_route_table (name: "private")
#     - Add a route for 0.0.0.0/0 pointing to the NAT Gateway (when enabled)
#
#   aws_route_table_association (name: "private", one per private subnet)
#
#   aws_security_group (name: "default")
#     - Sensible ingress/egress rules for the environment
#
# Hints:
#   - Use merge(var.tags, { Name = "..." }) on all resources for consistent tagging
#   - Use var.name as a prefix on all Name tags
#   - The NAT Gateway must be in a public subnet and requires the Internet Gateway to exist first
