terraform {
  backend "s3" {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "globalvars" {
  backend = "s3"
  config = {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/_global/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "dev_network" {
  source                = "git@github.com:konstantinTarletski/aws_terraform_modules.git//network"
  environment           = "dev"
  db_subnets_cidrs      = []
  private_subnets_cidrs = []
  //public_subnets_cidrs  = ["10.0.1.0/24", ]
  default_tags = data.terraform_remote_state.globalvars.outputs.default_tags
}

output "vpc_id" {
  value = module.dev_network.vpc_id
}

output "public_subnets_ids" {
  value = module.dev_network.public_subnets_ids
}
