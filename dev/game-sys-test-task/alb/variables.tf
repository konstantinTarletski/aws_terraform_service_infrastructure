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

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}