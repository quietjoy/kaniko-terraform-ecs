variable "identifier" {
  type        = string
  description = "Identifier for the ECS resources"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "IDs of the public subnets"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "IDs of the private subnets"
}

variable "inbound_cidr_whitelist" {
  type        = list(string)
  description = "CIDRs allowed to access the ALB"
}

variable "kankio_ecr_url" {
  type        = string
  description = "URL of the Kankio ECR repository"
}
