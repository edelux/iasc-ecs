
output "registry" {
  value = {
    for service in var.micro_services :
    service => {
      repository_url = module.registry[service].repository_url
    }
  }
}

output "registry_base_url" {
  value = var.ecr_base_url
}
