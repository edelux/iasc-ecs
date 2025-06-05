
## Infra
data "terraform_remote_state" "infra" {
  backend = "s3"

  config = {
    bucket       = "github-eenee2ma9ohxeiquua2ingaipaz6eerahsugheesaen9asa3fee1koor"
    key          = "env:/${terraform.workspace}/infra/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}




## VPC
variable "region" {
  description = "AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^(us-(east|west)-[12])$", var.region))
    error_message = "The region must be either us-east-1, us-east-2, us-west-1, or us-west-2."
  }
}

variable "environment" { #REQUIRED
  description = "Environment Name (dev, qa, stg, prod)"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^(qa|dev|st[ag]|pr[do])[a-z0-9]{0,9}$", var.environment))
    error_message = "The environment name must start with 'dev', 'qa', 'stg', 'pro', or 'prd', followed by up to 9 lowercase letters or numbers, with a total length between 2 and 12 characters."
  }

  validation {
    condition     = terraform.workspace == var.environment
    error_message = "Invalid workspace: The active workspace '${terraform.workspace}' does not match the specified environment '${var.environment}'."
  }
}




locals {

  config_file = file("${path.module}/config.yaml")
  config      = yamldecode(local.config_file)

  env_config = local.config.environments[var.environment]

  project           = local.config.project
  ecr_base_url      = "${local.env_config.cloud.account_id}.dkr.ecr.${local.env_config.cloud.region}.amazonaws.com"
  micro_services    = local.env_config.cluster.micro_services
  dynamic_hosts     = local.env_config.cluster.dynamic_hosts
  statics_hosts_max = local.env_config.cluster.statics_hosts_max
}
