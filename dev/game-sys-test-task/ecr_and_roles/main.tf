data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "dev/game-sys-test-task/_shared/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "dev_ecr_repo" {
  source                = "git@github.com:konstantinTarletski/aws_terraform_modules.git//ecr_and_iam_role?ref=v1.1.0"

  ecr_repository_name       = data.terraform_remote_state.shared.outputs.ecr_repository_name_game_sys_test_task
  git_repository_name       = data.terraform_remote_state.shared.outputs.git_repository_name_game_sys_test_task
  git_repository_owner      = var.git_repository_owner_konstantin_tarletski_name
  git_repository_token_link = "https://token.actions.githubusercontent.com"
  ecr_force_delete          = true
  default_tags              = var.default_tags
}

output "ecr_url" {
  value = module.dev_ecr_repo.aws_ecr_repository_url
}

output "git_open_id_provider_arn" {
  value = module.dev_ecr_repo.git_open_id_provider_arn
}
