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

/*module "dev-network" {
  source      = "git@github.com:konstantinTarletski/aws_terraform_modules.git//network"
  environment = "dev"
  default_tags = {
    Manufactor = "terraform",
    Design     = "tarlekon",
    Source     = "module"
  }
}*/

module "dev-ecr-repo" {
  source      = "git@github.com:konstantinTarletski/aws_terraform_modules.git//ecr_and_iam_role"
  ecr_repository_name = "game-sys-test-task"
  git_repository_name = "game-sys-test-task"
  git_repository_owner = "konstantinTarletski"
  git_repository_token_link = "https://token.actions.githubusercontent.com"
  ecr_force_delete = true
  default_tags = {
    Manufactor = "terraform",
    Design     = "tarlekon",
    Source     = "module"
  }
}
