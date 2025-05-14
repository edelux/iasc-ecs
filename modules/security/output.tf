
output "postgresql_sg_id" {
  description = "RDS Postgres Security Group ID"
  value       = module.postgresql_security_group.security_group_id
}

output "postgresql_sg_arn" {
  description = "RDS Postgres Security Group ARN"
  value       = module.postgresql_security_group.security_group_arn
}

output "postgresql_sg_name" {
  description = "RDS Postgres Security Group Name"
  value       = module.postgresql_security_group.security_group_name
}

output "ssh_sg_id" {
  description = "SSH Security Group ID"
  value       = module.ssh_security_group.security_group_id
}

output "ssh_sg_arn" {
  description = "SSH Security Group ARN"
  value       = module.ssh_security_group.security_group_id
}

output "ssh_sg_name" {
  description = "SSH Security Group Name"
  value       = module.ssh_security_group.security_group_name
}
