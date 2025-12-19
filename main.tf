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

module "dev-network" {
  source = "git@github.com:konstantinTarletski/aws_terraform_modules.git//network"

}