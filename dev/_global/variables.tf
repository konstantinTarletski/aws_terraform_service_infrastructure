variable "region" {
  description = "AWS Region for resources and provider"
  type        = string
  default     = "eu-central-1"
}

variable "state_bucket" {
  description = "S3 bucket for terraform state"
  type        = string
  default     = "tarlekon-self-aws-terraform-service-infrastructure"
}
