include "root" {
  path = find_in_parent_folders()
}

dependency "_global" {
  config_path = "../../_global"

  mock_outputs = {
    default_tags = {
      Owner = "terragrunt-mock"
    }
    environment = "dev"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan", "validate"]
}

dependency "network" {
  config_path = "../../network"
}

dependency "_shared" {
  config_path = "../_shared"

  mock_outputs = {
    git_repository_name_game_sys_test_task = "mock-repo-name"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan", "validate"]
}