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

variable "alb_port_mappings" {
  type = map(object({
    host = string
    priority = number
    health_check = string
  }))
  description = "Multiple port mappings for application in ALB"
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "game_sys_application_access_cidr" {
  description = "CIDR for game-sys-application access (ALB)"
  type        = list(string)
}
