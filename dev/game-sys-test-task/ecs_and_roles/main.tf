terraform {
  backend "s3" {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/game-sys-test-task/ecs_and_roles/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {}

data "aws_region" "current" {}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "globalvars" {
  backend = "s3"
  config = {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/_global/terraform.tfstate"
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

data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/game-sys-test-task/ecr_and_roles/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "dev_ecs_service" {
  source = "git@github.com:konstantinTarletski/aws_terraform_modules.git//ecs_service_and_iam_roles"

  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  subnets_ids        = data.terraform_remote_state.network.outputs.public_subnets_ids
  ecr_repository_url = data.terraform_remote_state.ecr.outputs.ecr_url

  git_repository_owner = data.terraform_remote_state.globalvars.outputs.git_repository_owner_konstantin_tarletski_name
  git_repository_name  = data.terraform_remote_state.shared.outputs.git_repository_name_game_sys_test_task
  ecr_repository_name  = data.terraform_remote_state.shared.outputs.ecr_repository_name_game_sys_test_task

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
  git_open_id_provider_arn = data.terraform_remote_state.ecr.outputs.git_open_id_provider_arn
  //depends_on = [module.dev_network, module.dev_ecr_repo]
}
