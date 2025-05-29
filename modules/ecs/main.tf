
module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "${terraform.workspace}-${var.project}-ecs"

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = var.statics_hosts_max
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = var.dynamic_hosts
      }
    }
  }

  services = {
    for service in var.micro_services : service => {
      desired_count    = 0
      cpu              = 256
      memory           = 512
      assign_public_ip = true
      launch_type      = "FARGATE"
      subnet_ids       = var.private_subnet_ids

      container_definitions = {
        "${service}" = {
          cpu                      = 64
          memory                   = 64
          essential                = true
          image                    = "${var.ecr_base_url}/${var.project}/${service}:latest"
          readonly_root_filesystem = false

          port_mappings = [
            {
              name          = "http"
              protocol      = "tcp"
              containerPort = 80
            }
          ]
        }
      }

      subnet_ids = var.private_subnet_ids

      security_group_rules = {
        alb_ingress = {
          type        = "ingress"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          description = "HTTP port"
          cidr_blocks = ["0.0.0.0/0"]
        }

        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }

      load_balancer = {
        service = {
          target_group_arn = module.alb[service].target_groups["default-instance"].arn
          container_name   = service
          container_port   = 80
        }
      }
    }
  }

  tags = {
    Terraform   = "true"
    Project     = var.project
    Environment = terraform.workspace
  }
  depends_on = [module.alb]
}

## LoadBalancer
module "alb" {
  source   = "terraform-aws-modules/alb/aws"
  for_each = toset(var.micro_services)

  internal                   = false
  vpc_id                     = var.vpc_id
  load_balancer_type         = "application"
  subnets                    = var.public_subnet_ids
  name                       = "${each.key}-${terraform.workspace}-${var.project}alb"
  enable_deletion_protection = false

  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTP web traffic"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTPS web traffic"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = var.vpc_cidr
    }
  }

  listeners = {
    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = var.ssl_certificate_arn[each.key]
      forward = {
        target_group_key = "default-instance"
      }
    },
    http = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  target_groups = {
    "default-instance" = {
      name_prefix = "ecstg"
      port        = 80
      target_type = "ip"
      protocol    = "HTTP"
      vpc_id      = var.vpc_id
      target_id   = var.target_id
    }
  }

  tags = {
    Terraform   = "true"
    Project     = var.project
    Environment = terraform.workspace
  }
}

## DNS
module "route53_A_to_CNAME_records" {
  source   = "terraform-aws-modules/route53/aws//modules/records"
  for_each = toset(var.micro_services)

  zone_name = var.domain
  records = [
    {
      name = "${each.key}"
      type = "A"
      alias = {
        name                   = module.alb[each.key].dns_name
        zone_id                = module.alb[each.key].zone_id
        evaluate_target_health = true
      }
    }
  ]
}
