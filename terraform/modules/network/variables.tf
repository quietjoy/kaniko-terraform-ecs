variable "identifier" {
  type        = string
  description = "identifier to add to the name of the resources"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the public subnets"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "availability zones to use for the network resources"
}
