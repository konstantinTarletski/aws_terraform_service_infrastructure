terraform {
  backend "s3" {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/_global/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {}

output "git_repository_owner_konstantin_tarletski_name" {
  value = "konstantinTarletski"
}

output "default_tags" {
  value = {
    Manufactor = "terraform",
    Design     = "tarlekon",
    Source     = "module"
  }
}
