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

dependency "alb" {
  config_path = "../alb"

  mock_outputs = {
    alb_sg_id = "sg-mock-12345"
    ports_and_tg_arns_map = {
      "8080" = { tg_arn = "arn:aws:elasticloadbalancing:eu-central-1:123456789012:targetgroup/mock-tg/1234567890" }
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "ecr" {
  config_path = "../ecr_and_roles"

  mock_outputs = {
    aws_ecr_repository_url   = "https://123456789012.dkr.ecr.eu-west-1.amazonaws.com/game-sys-test-task"
    git_open_id_provider_arn = "arn:aws:elasticloadbalancing:eu-central-1:123456789012:targetgroup/mock-tg/1234567890"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

locals {
  app_vars = read_terragrunt_config(find_in_parent_folders("app_variables.hcl"))
}

inputs = {
  git_repository_owner_name                 = local.app_vars.locals.git_repository_owner_name
  git_repository_name_game_sys_test_task    = local.app_vars.locals.git_repository_name_game_sys_test_task
  ecr_repository_name_game_sys_test_task    = local.app_vars.locals.ecr_repository_name_game_sys_test_task
  environment_variables                     = local.app_vars.locals.environment_variables
  game_sys_application_cloudwatch_log_group = local.app_vars.locals.game_sys_application_cloudwatch_log_group
  game_sys_application_port                 = local.app_vars.locals.game_sys_application_port

  vpc_id                   = dependency.network.outputs.vpc_id
  public_subnets_ids       = dependency.network.outputs.public_subnets_ids
  alb_sg_id                = dependency.alb.outputs.alb_sg_id
  ports_and_tg_arns_map    = dependency.alb.outputs.ports_and_tg_arns_map
  aws_ecr_repository_url   = dependency.ecr.outputs.aws_ecr_repository_url
  git_open_id_provider_arn = dependency.ecr.outputs.git_open_id_provider_arn
}