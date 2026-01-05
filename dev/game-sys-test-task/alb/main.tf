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
  //alb_sg_egress_ports_and_sg  -- add later, see "add_link_to_sg"
  alb_sg_egress_ports_and_cidr  = {}
}

data "terraform_remote_state" "ecs" {
  backend = "s3"
  config = {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/game-sys-test-task/ecs_and_roles/terraform.tfstate"
    region = "eu-central-1"
  }
  depends_on             = [module.dev_alb]
}

module "add_link_to_sg" {
  source                 = "git@github.com:konstantinTarletski/aws_terraform_modules.git//sg_rule_constructor"
  security_group_id      = module.dev_alb.alb_sg_id
  egress_ports_and_sg    = {"8815" = [data.terraform_remote_state.ecs.ecs_sg_id]}
  depends_on             = [module.dev_alb]
}