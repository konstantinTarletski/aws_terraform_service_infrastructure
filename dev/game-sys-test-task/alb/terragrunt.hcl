include "root" {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../../network"
  mock_outputs = {
    vpc_id = "vpc-mock-12345"
    public_subnets_ids = ["subnet-mock-1", "subnet-mock-2"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

locals {
  app_vars = read_terragrunt_config(find_in_parent_folders("app_variables.hcl"))
}

inputs = {
  git_repository_name_game_sys_test_task = local.app_vars.locals.git_repository_name_game_sys_test_task
  vpc_id                                 = dependency.network.outputs.vpc_id
  public_subnets_ids                     = dependency.network.outputs.public_subnets_ids
}