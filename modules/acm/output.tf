
output "acm_certificate_arn" {
  description = "The ARN of the certificate for each microservice"
  value       = { for k, m in module.acm : k => m.acm_certificate_arn }
}

output "acm_certificate_status" {
  description = "Status of the certificate for each microservice"
  value       = { for k, m in module.acm : k => m.acm_certificate_status }
}

output "distinct_domain_names" {
  description = "List of distinct domain names used for the validation for each microservice"
  value       = { for k, m in module.acm : k => m.distinct_domain_names }
}
