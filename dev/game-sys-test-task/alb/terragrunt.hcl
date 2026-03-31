include "root" {
  path = find_in_parent_folders()
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