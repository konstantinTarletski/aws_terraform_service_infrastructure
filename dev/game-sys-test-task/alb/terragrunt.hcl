include "root" {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../../network"
}

locals {
  app_vars = read_terragrunt_config(find_in_parent_folders("app_variables.hcl"))
}

inputs = {
  git_repository_name_game_sys_test_task = local.app_vars.locals.git_repository_name_game_sys_test_task
}