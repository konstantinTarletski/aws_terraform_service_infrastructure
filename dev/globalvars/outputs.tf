terraform {
  backend "s3" {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/globalvars/terraform.tfstate"
    region = "eu-central-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}

provider "aws" {}

output "ecr_repository_name_game_sys_test_task" {
  value = "game-sys-test-task"
}

output "git_repository_name_game_sys_test_task" {
  value = "game-sys-test-task"
}

output "game_sys_test_task_application_name" {
  value = "game-sys-test-task"
}

output "default_tags" {
  value = {
    Manufactor = "terraform",
    Design     = "tarlekon",
    Source     = "module"
  }
}
