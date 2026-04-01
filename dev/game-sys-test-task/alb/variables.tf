variable "default_tags" {
  description = "Default tags"
  type        = map(string)
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "git_repository_name_game_sys_test_task" {
  description = "GIT repository name for game-sys-test-task"
  type        = string
}

variable "vpc_id" {
  type = string
  description = "Virtual private cloud (VPC) ID"
}

variable "public_subnets_ids" {
  type = list(string)
  description = "Virtual private cloud (VPC) subnets IDs"
}