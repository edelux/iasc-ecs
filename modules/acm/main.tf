
module "acm" {
  source   = "terraform-aws-modules/acm/aws"
  for_each = toset(var.micro_services)

  domain_name               = "${each.key}.${var.domain}"
  validation_method         = "DNS"
  wait_for_validation       = true
  zone_id                   = var.zone_id
  subject_alternative_names = []
  tags = {
    Environment  = terraform.workspace
    MicroService = each.key
  }
}
