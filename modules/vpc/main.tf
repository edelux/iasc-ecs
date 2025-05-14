
data "aws_availability_zones" "available" { state = "available" }

locals {
  azs                  = slice(data.aws_availability_zones.available.names, 0, var.az_numbers)
  public_subnets       = [for i in range(var.az_numbers) : cidrsubnet(var.vpc_cidr, var.subnet_bits_mask, i)]
  private_subnets      = [for i in range(var.az_numbers) : cidrsubnet(var.vpc_cidr, var.subnet_bits_mask, i + var.az_numbers)]
  private_subnet_names = [for i in range(var.az_numbers) : "${terraform.workspace}-private-subnet${i + 1}"]
  public_subnet_names  = [for i in range(var.az_numbers) : "${terraform.workspace}-public-subnet${i + 1}"]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  azs                    = local.azs
  cidr                   = var.vpc_cidr
  name                   = "${terraform.workspace}-vpc"
  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  public_subnets         = local.public_subnets
  public_subnet_names    = local.public_subnet_names
  private_subnets        = local.private_subnets
  private_subnet_names   = local.private_subnet_names

  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }
}
