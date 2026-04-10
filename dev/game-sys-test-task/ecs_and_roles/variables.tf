variable "default_tags" {
  description = "Default tags"
  type        = map(string)
}

variable "git_repository_owner_name" {
  description = "Git repository owner name"
  type        = string
}

variable "git_repository_name_game_sys_test_task" {
  description = "GIT repository name for game-sys-test-task"
  type        = string
}

variable "ecr_repository_name_game_sys_test_task" {
  description = "ECR repository name for game-sys-test-task"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for game-sys-test-task application"
  type = list(object({
    name  = string
    value = string
  }))
}

variable "vpc_id" {
  type = string
  description = "Virtual private cloud (VPC) ID"
}

variable "public_subnets_ids" {
  type = list(string)
  description = "Virtual private cloud (VPC) subnets IDs"
}

variable "aws_ecr_repository_url" {
  type = string
  description = "AWS ECR repository URL"
}

variable "game_sys_application_cloudwatch_log_group" {
  type = string
  description = "AWS cloudwatch log group for gameSys"
}

variable "game_sys_application_port" {
  type = string
  description = "gameSys application port"
}

variable "ports_and_tg_arns_map" {
  type        = map(object({ tg_arn = string }))
  description = "Application ports allowed for ingress for ECS 8080 default for tomcat 'tg_arn' - for \"link\" with load_balancer"
}

variable "alb_sg_id" {
  type = string
  description = "ALB security group ID, to connect with ECS security group"
}

variable "git_open_id_provider_arn" {
  type = string
  description = "Git OpenID provider ARN"
}
