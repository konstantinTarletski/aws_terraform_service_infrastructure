variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "default_tags" {
  description = "Default tags"
  type        = map(string)
}