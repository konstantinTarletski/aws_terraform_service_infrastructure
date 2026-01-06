terraform {
  backend "s3" {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/game-sys-test-task/alb/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {}

data "terraform_remote_state" "globalvars" {
  backend = "s3"
  config = {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/_global/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/game-sys-test-task/_shared/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "dev_alb" {
  source                        = "git@github.com:konstantinTarletski/aws_terraform_modules.git//alb_and_ssl"
  default_tags                  = data.terraform_remote_state.globalvars.outputs.default_tags
  vpc_id                        = data.terraform_remote_state.network.outputs.vpc_id
  subnets_ids                   = data.terraform_remote_state.network.outputs.public_subnets_ids
  environment                   = data.terraform_remote_state.globalvars.outputs.environment
  project_name                  = data.terraform_remote_state.shared.outputs.git_repository_name_game_sys_test_task
  alb_port                      = 80
  alb_protocol                  = "HTTP"
  alb_port_mappings             = { "8815" = { path_pattern = "/*", priority = 10, health_check = "/swagger-ui.html", is_default = true } }
  alb_sg_ingress_ports_and_sg   = {}
  //alb_sg_ingress_ports_and_cidr = { "80" = ["0.0.0.0/0"] } -- default
  //alb_sg_egress_ports_and_sg  -- add later, see "add_ecs_sg_to_alb_sg"
  alb_sg_egress_ports_and_cidr  = {}
}

output "alb_sg_id" {
  value = module.dev_alb.alb_sg_id
}

output "ports_with_target_groups" {
  value = module.dev_alb.ports_with_target_groups
  description = "Example: ['80080' = 'arn:tg-123']"
}

output "ports_and_tg_arns_map" {
  value = module.dev_alb.ports_and_tg_arns_map
  description = "Example: ['80080' = {tg_arn = 'arn:tg-123'}]"
}
