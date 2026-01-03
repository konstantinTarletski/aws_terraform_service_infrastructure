terraform {
  backend "s3" {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/game-sys-test-task/_shared/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {}

output "ecr_repository_name_game_sys_test_task" {
  value = "game-sys-test-task"
}

output "git_repository_name_game_sys_test_task" {
  value       = "game-sys-test-task"
  description = "Used like application name"
}

output "game_sys_test_task_application_port_mappings" {
  value       = { "8815" = { path_pattern = "/*", priority = 10, health_check = "/swagger-ui.html", is_default = true } }
  description = "8815 - api"
}

output "alb_port" {
  value       = 80
  description = "ALB port"
}

output "alb_protocol" {
  value       = "HTTP"
  description = "ALB protocol"
}

output "environment_variables" {
  value = [
    {
      "name" : "JAVA_TOOL_OPTIONS",
      "value" : "-Djava.rmi.server.hostname=127.0.0.1 -Dh2.bindAddress=127.0.0.1 -Dsun.net.inetaddr.ttl=0"
    }
  ]
  description = "game_sys_test_task environment values needed to run H2"
}

