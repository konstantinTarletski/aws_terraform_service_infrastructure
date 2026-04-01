module "dev_alb" {
  source               = "git@github.com:konstantinTarletski/aws_terraform_modules.git//alb_and_ssl?ref=v1.1.0"
  default_tags         = var.default_tags
  vpc_id               = var.vpc_id
  subnets_ids          = var.public_subnets_ids
  environment          = var.environment
  project_name         = var.git_repository_name_game_sys_test_task
  alb_port_mappings    = { "8815" = { host = "game-sys", priority = 10, health_check = "/swagger-ui.html" } }
  existing_domain_name = "tarlekon.click"
  alb_sg_cidr          = ["0.0.0.0/0"]
}

output "alb_sg_id" {
  value = module.dev_alb.alb_sg_id
}

output "ports_with_target_groups" {
  value       = module.dev_alb.ports_with_target_groups
  description = "Example: ['80080' = 'arn:tg-123']"
}

output "ports_and_tg_arns_map" {
  value       = module.dev_alb.ports_and_tg_arns_map
  description = "Example: ['80080' = {tg_arn = 'arn:tg-123'}]"
}
