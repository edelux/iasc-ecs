
module "ecr" {
  source         = "./modules/registry"
  ecr_base_url   = local.ecr_base_url
  micro_services = local.micro_services
}

module "acm" {
  source         = "./modules/acm"
  micro_services = local.micro_services
  ecr_base_url   = local.ecr_base_url
  domain         = values(data.terraform_remote_state.infra.outputs.domain_zone_name)[0]
  zone_id        = data.terraform_remote_state.infra.outputs.domain_zone_id[values(data.terraform_remote_state.infra.outputs.domain_zone_name)[0]]
}

module "ecs" {
  source               = "./modules/ecs"
  ecr_base_url         = local.ecr_base_url
  dynamic_hosts        = local.dynamic_hosts
  micro_services       = local.micro_services
  statics_hosts_max    = local.statics_hosts_max
  ssl_certificate_arn  = module.acm.acm_certificate_arn
  vpc_id               = data.terraform_remote_state.infra.outputs.vpc_id
  vpc_cidr             = data.terraform_remote_state.infra.outputs.vpc_cidr
  domain               = values(data.terraform_remote_state.infra.outputs.domain_zone_name)[0]
  public_subnet_ids    = data.terraform_remote_state.infra.outputs.public_subnet_ids
  private_subnet_ids   = data.terraform_remote_state.infra.outputs.private_subnet_ids
  private_subnet_cidrs = data.terraform_remote_state.infra.outputs.private_subnet_cidrs
  target_id            = cidrhost(data.terraform_remote_state.infra.outputs.private_subnet_cidrs[1], 10)
}
