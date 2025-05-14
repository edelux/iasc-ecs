## Global Ouput

## Variables
output "region" {
  description = "Region where the infrastructure is deployed"
  value       = local.env_config.cloud.region
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = local.env_config.networking.vpc_cidr
}

output "domain_name" {
  description = "FQDN Doname Name"
  value       = local.config.zone
}

output "registry_base_url" {
  value = local.ecr_base_url
}

output "ssl_certificate_arn" {
  value = local.env_config.security.ssl_certificate_arn
}

## VPC
output "vpc_id" {
  description = "VPC ID Created"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private Subnts list"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "Publics Subnts list"
  value       = module.vpc.public_subnet_ids
}

## ECS
output "cluster_id" {
  description = "ECS Cluster ID"
  value       = module.ecs.cluster_id
}

output "cluster_arn" {
  description = "ECS Cluster ARN"
  value       = module.ecs.cluster_arn
}

output "cluster_name" {
  description = "ECS Cluster NAME"
  value       = module.ecs.cluster_name
}
