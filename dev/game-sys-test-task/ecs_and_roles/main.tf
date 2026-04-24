data "aws_region" "current" {}

module "dev_ecs_service" {
  source = "git@github.com:konstantinTarletski/aws_terraform_modules.git//ecs_service_and_iam_roles?ref=v1.1.0"

  vpc_id             = var.vpc_id
  subnets_ids        = var.public_subnets_ids
  ecr_repository_url = var.aws_ecr_repository_url

  git_repository_owner = var.git_repository_owner_name
  git_repository_name  = var.git_repository_name_game_sys_test_task
  ecr_repository_name  = var.ecr_repository_name_game_sys_test_task

  aws_cloudwatch_log_group            = var.game_sys_application_cloudwatch_log_group
  region                              = data.aws_region.current.id
  docker_image_strict_pull_policy     = true
  ecs_sg_application_ports_and_tg_arn = var.ports_and_tg_arns_map
  ecs_sg_ingress_ports_and_sg         = { (var.game_sys_application_port) = [var.alb_sg_id] }
  environment_variables               = var.environment_variables
  default_tags                        = var.default_tags
  git_open_id_provider_arn            = var.git_open_id_provider_arn
}

module "add_ecs_sg_to_alb_sg" {
  source                    = "git@github.com:konstantinTarletski/aws_terraform_modules.git//sg_rule_constructor?ref=v1.1.0"
  security_group_id         = var.alb_sg_id
  egress_ports_and_sg_named = { "${var.game_sys_application_port}-add_ecs_sg_to_alb_sg" = { port = var.game_sys_application_port, sg_id = module.dev_ecs_service.ecs_sg_id } }
  depends_on                = [module.dev_ecs_service]
}

output "ecs_sg_id" {
  value = module.dev_ecs_service.ecs_sg_id
}
