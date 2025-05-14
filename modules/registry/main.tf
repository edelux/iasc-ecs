
module "registry" {
  source   = "terraform-aws-modules/ecr/aws"
  for_each = toset(var.micro_services)

  repository_name         = each.key
  repository_force_delete = true

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 3 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 3
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  public_repository_catalog_data = {
    description       = "Repository for ${each.key} application"
    operating_systems = ["Linux"]
    architectures     = ["x86_64"]
  }

  tags = {
    Terraform     = "true"
    Environment   = terraform.workspace
    MicroServicio = "${each.key}-ms"
  }
}
