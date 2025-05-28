
## Global Ouput
output "registry_base_url" {
  value = module.ecr.registry_base_url
}

output "registry" {
  value = module.ecr.registry
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
