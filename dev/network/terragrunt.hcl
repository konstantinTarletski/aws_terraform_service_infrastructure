include "root" {
  path = find_in_parent_folders()
}

dependency "_global" {
  config_path = "../_global"

  mock_outputs = {
    default_tags = {
      Owner = "terragrunt-mock"
    }
    environment = "dev"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan", "validate"]
}