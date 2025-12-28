terraform {
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

  vpc_id             = data.terraform_remote_state.infrastructure.outputs.vpc_id
  subnets_ids        = data.terraform_remote_state.infrastructure.outputs.public_subnets_ids
  ecr_repository_url = data.terraform_remote_state.infrastructure.outputs.ecr_url

  git_repository_owner = data.terraform_remote_state.globalvars.outputs.git_repository_owner_game_sys_test_task
  git_repository_name  = data.terraform_remote_state.globalvars.outputs.git_repository_name_game_sys_test_task
  ecr_repository_name  = data.terraform_remote_state.globalvars.outputs.ecr_repository_name_game_sys_test_task

  aws_cloudwatch_log_group        = "/ecs/game-sys-test-task"
  region                          = data.aws_region.current.id
  docker_image_strict_pull_policy = true
  application_ports               = [8815]
  environment_variables = [
    {
      "name": "JAVA_TOOL_OPTIONS",
      "value": "-Djava.rmi.server.hostname=127.0.0.1 -Dh2.bindAddress=127.0.0.1 -Dsun.net.inetaddr.ttl=0"
    }
  ]

  default_tags             = data.terraform_remote_state.globalvars.outputs.default_tags
  git_open_id_provider_arn = data.terraform_remote_state.infrastructure.outputs.git_open_id_provider_arn
  //depends_on = [module.dev_network, module.dev_ecr_repo]
}
