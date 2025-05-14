
output "vpc_id" {
  description = "VPC ID Created"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "VPC ARN"
  value       = module.vpc.vpc_arn
}

output "vpc_name" {
  description = "VPC Name"
  value       = module.vpc.name
}

output "availability_zones" {
  description = "Avaulability Zones List"
  value       = module.vpc.azs
}

output "private_subnet_ids" {
  description = "Private Subnts list"
  value       = module.vpc.private_subnets
}

output "private_subnet_arns" {
  description = "Private Subnts ARNs list"
  value       = module.vpc.private_subnet_arns
}

output "private_subnet_cidrs" {
  description = "Private Subnts CIDR list"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnet_ids" {
  description = "Publics Subnts list"
  value       = module.vpc.public_subnets
}

output "public_subnet_arns" {
  description = "Public Subnts ARNs list"
  value       = module.vpc.public_subnet_arns
}

output "public_subnet_cidrs" {
  description = "Public Subnts CIDR list"
  value       = module.vpc.public_subnets_cidr_blocks
}
