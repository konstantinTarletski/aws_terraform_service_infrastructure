locals {
  git_repository_owner_name = "konstantinTarletski"
  ecr_repository_name_game_sys_test_task = "game-sys-test-task"
  git_repository_name_game_sys_test_task = "game-sys-test-task"
  game_sys_test_task_application_port_mappings = {
    "8815" = { path_pattern = "/*", priority = 10, health_check = "/swagger-ui.html", is_default = true }
  }
  environment_variables = [
    {
      "name" : "JAVA_TOOL_OPTIONS",
      "value" : "-Djava.rmi.server.hostname=127.0.0.1 -Dh2.bindAddress=127.0.0.1 -Dsun.net.inetaddr.ttl=0"
    }
  ]
}