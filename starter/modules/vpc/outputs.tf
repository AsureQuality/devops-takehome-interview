output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets, in AZ order"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of IDs of the private subnets, in AZ order"
  value       = aws_subnet.private[*].id
}

output "default_security_group_id" {
  description = "ID of the default security group"
  value       = aws_security_group.default.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway (null if enable_nat_gateway is false)"
  value       = one(aws_nat_gateway.main[*].id)
}
