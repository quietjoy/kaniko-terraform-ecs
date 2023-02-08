output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public.*.id
  description = "IDs of the public subnets"
}

output "private_subnet_ids" {
  value       = aws_subnet.private.*.id
  description = "IDs of the private subnets"
}
