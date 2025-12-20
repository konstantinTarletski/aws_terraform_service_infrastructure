terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}
provider "aws" {

}

terraform {
  backend "s3" {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "dev-network" {
  source      = "git@github.com:konstantinTarletski/aws_terraform_modules.git//network"
  environment = "dev"
  default_tags = {
    Manufactor = "terraform",
    Design     = "tarlekon",
    Source     = "module"
  }
}
