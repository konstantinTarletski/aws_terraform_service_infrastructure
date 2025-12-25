terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "6.17.0" }
  }
  backend "s3" {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/ecs_service/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {}

data "aws_region" "current" {}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/infrastructure/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "globalvars" {
  backend = "s3"
  config = {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/globalvars/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "dev_ecs_service" {
  source = "git@github.com:konstantinTarletski/aws_terraform_modules.git//ecs_service_and_iam_roles"

  vpc_id = data.terraform_remote_state.infrastructure.outputs.vpc_id
  subnets_ids = data.terraform_remote_state.infrastructure.outputs.public_subnets_ids
  ecr_repository_url = data.terraform_remote_state.infrastructure.outputs.ecr_url

  application_name = data.terraform_remote_state.globalvars.outputs.game_sys_test_task_application_name
  ecr_repository_name = data.terraform_remote_state.globalvars.outputs.ecr_repository_name_game_sys_test_task
  aws_cloudwatch_log_group = "/ecs/game-sys-test-task"
  region = data.aws_region.current.id
  docker_image_strict_pull_policy = true
  application_ports = [8815]

  default_tags = data.terraform_remote_state.globalvars.outputs.default_tags
  //depends_on = [module.dev_network, module.dev_ecr_repo]
}
