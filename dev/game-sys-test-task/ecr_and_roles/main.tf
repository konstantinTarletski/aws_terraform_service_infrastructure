terraform {
  backend "s3" {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/game-sys-test-task/ecr_and_roles/terraform.tfstate"
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

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/game-sys-test-task/_shared/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "dev_ecr_repo" {
  //source                    = "git@github.com:konstantinTarletski/aws_terraform_modules.git//ecr_and_iam_role"
  source                = "git@github.com:konstantinTarletski/aws_terraform_modules.git//ecr_and_iam_role?ref=feature/alb-refactoring-improved"

  ecr_repository_name       = data.terraform_remote_state.shared.outputs.ecr_repository_name_game_sys_test_task
  git_repository_name       = data.terraform_remote_state.shared.outputs.git_repository_name_game_sys_test_task
  git_repository_owner      = data.terraform_remote_state.globalvars.outputs.git_repository_owner_konstantin_tarletski_name
  git_repository_token_link = "https://token.actions.githubusercontent.com"
  ecr_force_delete          = true
  default_tags              = data.terraform_remote_state.globalvars.outputs.default_tags
}

output "ecr_url" {
  value = module.dev_ecr_repo.aws_ecr_repository_url
}

output "git_open_id_provider_arn" {
  value = module.dev_ecr_repo.git_open_id_provider_arn
}
