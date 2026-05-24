variable "name" {
  description = "Name prefix applied to all resources created by this module"
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC (e.g. 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zone names to deploy subnets into (minimum 2 required)"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets, one per availability zone"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets, one per availability zone"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "When true, a NAT Gateway is created in the first public subnet for private subnet egress"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Map of additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
