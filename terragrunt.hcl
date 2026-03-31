locals {
  region                                         = "eu-central-1"
  state_bucket                                   = "tarlekon-self-aws-terraform-service-infrastructure"
  environment                                    = "dev"
  git_repository_owner_konstantin_tarletski_name = "konstantinTarletski"
  default_tags = {
    Manufactor = "terraform"
    Design     = "tarlekon"
    Source     = "terragrunt"
  }
}

inputs = {
  region                                         = local.region
  state_bucket                                   = local.state_bucket
  environment                                    = local.environment
  git_repository_owner_konstantin_tarletski_name = local.git_repository_owner_konstantin_tarletski_name
  default_tags                                   = local.default_tags
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    bucket  = local.state_bucket
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = local.region
    encrypt = true
    #use_lockfile = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}