
## POSTGRESQL
module "postgresql_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "postgresql_sg"
  vpc_id      = var.vpc_id
  description = "RDS Postgres for Bastion Security Group"

  ingress_cidr_blocks = [var.vpc_cidr]
  ingress_rules       = ["postgresql-tcp"]

  egress_cidr_blocks = [var.vpc_cidr]
  egress_rules       = ["all-all"]

  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }
}

## SSH
module "ssh_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ssh_sg"
  vpc_id      = var.vpc_id
  description = "Bastion SSH Security Group"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }
}
