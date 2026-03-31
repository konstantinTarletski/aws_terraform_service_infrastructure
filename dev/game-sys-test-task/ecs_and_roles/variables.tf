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