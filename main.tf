terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}
provider "aws" {

}

terraform {
  backend "s3" {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

locals {
  ecr_repository_name = "game-sys-test-task"
  git_repository_name = "game-sys-test-task"
}

data "aws_region" "current" {}

module "dev_network" {
  source                = "git@github.com:konstantinTarletski/aws_terraform_modules.git//network"
  environment           = "dev"
  db_subnets_cidrs      = []
  private_subnets_cidrs = []
  //public_subnets_cidrs  = ["10.0.1.0/24", ]
  default_tags = {
    Manufactor = "terraform",
    Design     = "tarlekon",
    Source     = "module"
  }
}

module "dev_ecr_repo" {
  source                    = "git@github.com:konstantinTarletski/aws_terraform_modules.git//ecr_and_iam_role"
  ecr_repository_name       = local.ecr_repository_name
  git_repository_name       = local.git_repository_name
  git_repository_owner      = "konstantinTarletski"
  git_repository_token_link = "https://token.actions.githubusercontent.com"
  ecr_force_delete          = true
  default_tags = {
    Manufactor = "terraform",
    Design     = "tarlekon",
    Source     = "module"
  }
}

module "dev_ecs_service" {
  source = "git@github.com:konstantinTarletski/aws_terraform_modules.git//ecs_service_and_iam_roles"
  application_name = local.git_repository_name
  aws_cloudwatch_log_group = "/ecs/game-sys-test-task"
  ecr_repository_name = local.ecr_repository_name
  region = data.aws_region.current.id
  subnets_ids = module.dev_network.public_subnets_ids
  vpc_id = module.dev_network.vpc_id
  docker_image_name = "tomcat:latest"//TODO FIXME
  docker_image_strict_pull_policy = false //TODO FIXME
  depends_on = [module.dev_network]
}
