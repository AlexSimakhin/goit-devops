variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for the subnet layout"
  type        = list(string)
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT gateways"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Whether to use a single NAT gateway"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Whether to create one NAT gateway per availability zone"
  type        = bool
  default     = true
}