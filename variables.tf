
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

variable "environment" {
  description = "Environment Name (dev, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = can(regex("^(qa|dev|st[ag]|pr[do])[a-z0-9]{0,9}$", var.environment))
    error_message = "The environment name must start with 'dev', 'qa', 'stg', 'pro', or 'prd', followed by up to 9 lowercase letters or numbers, with a total length between 2 and 12 characters."
  }

  validation {
    condition     = terraform.workspace == var.environment
    error_message = "Invalid workspace: The active workspace '${terraform.workspace}' does not match the specified environment '${var.environment}'."
  }
}
