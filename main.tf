
locals {
  config_file = file("${path.module}/config.yaml")
  config      = yamldecode(local.config_file)

  env_config = local.config.environments[var.environment]

  vpc_cidr            = local.env_config.networking.vpc_cidr
  az_numbers          = local.env_config.networking.availability_zones
  subnet_bits_mask    = local.env_config.networking.subnet_bits_mask
  ecr_base_url        = "${local.env_config.cloud.account_id}.dkr.ecr.${local.env_config.cloud.region}.amazonaws.com"
  micro_services      = local.env_config.cluster.micro_services
  dynamic_hosts       = local.env_config.cluster.dynamic_hosts
  statics_hosts_max   = local.env_config.cluster.statics_hosts_max
  ssl_certificate_arn = local.env_config.security.ssl_certificate_arn
  domain_name         = local.env_config.dns.domain_name
}

module "vpc" {
  source           = "./modules/vpc"
  vpc_cidr         = local.vpc_cidr
  az_numbers       = local.az_numbers
  subnet_bits_mask = local.subnet_bits_mask
}

module "security" {
  source   = "./modules/security"
  vpc_cidr = local.vpc_cidr
  vpc_id   = module.vpc.vpc_id
}

module "ecr" {
  source         = "./modules/registry"
  ecr_base_url   = local.ecr_base_url
  micro_services = local.micro_services
}

module "ecs" {
  source               = "./modules/ecs"
  vpc_id               = module.vpc.vpc_id
  vpc_cidr             = local.vpc_cidr
  domain_name          = local.env_config.dns.domain_name
  ecr_base_url         = local.ecr_base_url
  dynamic_hosts        = local.dynamic_hosts
  micro_services       = local.micro_services
  statics_hosts_max    = local.statics_hosts_max
  ssl_certificate_arn  = local.ssl_certificate_arn
  public_subnet_ids    = module.vpc.public_subnet_ids
  private_subnet_ids   = module.vpc.private_subnet_ids
  private_subnet_cidrs = module.vpc.private_subnet_cidrs
  target_id            = cidrhost(module.vpc.private_subnet_cidrs[1], 10)
}
