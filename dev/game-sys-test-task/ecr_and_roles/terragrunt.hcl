include "root" {
  path = find_in_parent_folders()
}

locals {
  app_vars = read_terragrunt_config(find_in_parent_folders("app_variables.hcl"))
  github_token_url = "https://token.actions.githubusercontent.com"
}

inputs = {
  git_repository_owner_name              = local.app_vars.locals.git_repository_owner_name
  git_repository_name_game_sys_test_task = local.app_vars.locals.git_repository_name_game_sys_test_task
  ecr_repository_name_game_sys_test_task = local.app_vars.locals.ecr_repository_name_game_sys_test_task
  git_repository_token_link              = local.github_token_url
}