variable "region" {
  description = "AWS Region for resources and provider"
  type        = string
}

variable "state_bucket" {
  description = "S3 bucket for terraform state"
  type        = string
}

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