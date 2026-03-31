data "aws_region" "current" {}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "dev/game-sys-test-task/_shared/terraform.tfstate"
    region = var.region
  }
}


data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "dev/network/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "dev/game-sys-test-task/ecr_and_roles/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "dev/game-sys-test-task/alb/terraform.tfstate"
    region = var.region
  }
}

module "dev_ecs_service" {
  source = "git@github.com:konstantinTarletski/aws_terraform_modules.git//ecs_service_and_iam_roles?ref=v1.1.0"

  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  subnets_ids        = data.terraform_remote_state.network.outputs.private_subnets_ids
  ecr_repository_url = data.terraform_remote_state.ecr.outputs.ecr_url

  git_repository_owner = var.git_repository_owner_konstantin_tarletski_name
  git_repository_name  = data.terraform_remote_state.shared.outputs.git_repository_name_game_sys_test_task
  ecr_repository_name  = data.terraform_remote_state.shared.outputs.ecr_repository_name_game_sys_test_task

  aws_cloudwatch_log_group            = "/ecs/game-sys-test-task"
  region                              = data.aws_region.current.id
  docker_image_strict_pull_policy     = true
  ecs_sg_application_ports_and_tg_arn = data.terraform_remote_state.alb.outputs.ports_and_tg_arns_map
  ecs_sg_ingress_ports_and_sg         = { "8815" = [data.terraform_remote_state.alb.outputs.alb_sg_id] }
  environment_variables               = data.terraform_remote_state.shared.outputs.environment_variables
  default_tags                        = var.default_tags
  git_open_id_provider_arn            = data.terraform_remote_state.ecr.outputs.git_open_id_provider_arn
}

module "add_ecs_sg_to_alb_sg" {
  source              = "git@github.com:konstantinTarletski/aws_terraform_modules.git//sg_rule_constructor?ref=v1.1.0"
  security_group_id   = data.terraform_remote_state.alb.outputs.alb_sg_id
  egress_ports_and_sg_named = { "8815-add_ecs_sg_to_alb_sg" = {port = "8815", sg_id = module.dev_ecs_service.ecs_sg_id}}
  depends_on          = [module.dev_ecs_service]
}

output "ecs_sg_id" {
  value = module.dev_ecs_service.ecs_sg_id
}
