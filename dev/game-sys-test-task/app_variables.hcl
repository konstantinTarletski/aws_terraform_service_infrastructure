locals {
  git_repository_owner_name                 = "konstantinTarletski"
  ecr_repository_name_game_sys_test_task    = "game-sys-test-task"
  git_repository_name_game_sys_test_task    = "game-sys-test-task"
  domain_name                               = "tarlekon.click"
  game_sys_application_port                 = "8815"
  game_sys_application_host                 = "game-sys"
  game_sys_application_access_cidr = ["0.0.0.0/0"]
  game_sys_application_cloudwatch_log_group = "/ecs/game-sys-test-task"
  game_sys_test_task_application_port_mappings = {
    (local.game_sys_application_port) = {
      host = local.game_sys_application_host, priority = 10, health_check = "/swagger-ui.html"
    }
  }
  environment_variables = [
    {
      "name" : "JAVA_TOOL_OPTIONS",
      "value" : "-Djava.rmi.server.hostname=127.0.0.1 -Dh2.bindAddress=127.0.0.1 -Dsun.net.inetaddr.ttl=0"
    }
  ]
}