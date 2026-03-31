include "root" {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../../network"
}

dependency "alb" {
  config_path = "../alb"
}

dependency "ecr" {
  config_path = "../ecr_and_roles"
}

locals {
  app_vars = read_terragrunt_config(find_in_parent_folders("app_variables.hcl"))
}

inputs = {
  git_repository_owner_name              = local.app_vars.locals.git_repository_owner_name
  git_repository_name_game_sys_test_task = local.app_vars.locals.git_repository_name_game_sys_test_task
  ecr_repository_name_game_sys_test_task = local.app_vars.locals.ecr_repository_name_game_sys_test_task
  environment_variables                  = local.app_vars.locals.environment_variables
}