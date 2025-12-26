terraform {
  backend "s3" {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/globalvars/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {}

output "ecr_repository_name_game_sys_test_task" {
  value = "game-sys-test-task"
}

output "git_repository_name_game_sys_test_task" {
  value = "game-sys-test-task"
}

output "git_repository_owner_game_sys_test_task" {
  value = "konstantinTarletski"
}

output "default_tags" {
  value = {
    Manufactor = "terraform",
    Design     = "tarlekon",
    Source     = "module"
  }
}
