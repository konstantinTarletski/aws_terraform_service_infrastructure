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

variable "git_repository_owner_konstantin_tarletski_name" {
  description = "Git repository owner name"
  type        = string
}