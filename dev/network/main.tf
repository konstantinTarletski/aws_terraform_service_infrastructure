data "terraform_remote_state" "globalvars" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "dev/_global/terraform.tfstate"
    region = var.region
  }
}

module "dev_network" {
  source                = "git@github.com:konstantinTarletski/aws_terraform_modules.git//network?ref=v1.1.0"
  environment           = "dev"
  db_subnets_cidrs      = [] //"10.0.201.0/24",-- default value
  //private_subnets_cidrs = [ "10.0.101.0/24",] -- default value
  //ALB needs 2 AZ minimum
  public_subnets_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  default_tags = data.terraform_remote_state.globalvars.outputs.default_tags
}

output "vpc_id" {
  value = module.dev_network.vpc_id
}

output "public_subnets_ids" {
  value = module.dev_network.public_subnets_ids
}

output "private_subnets_ids" {
  value = module.dev_network.private_subnets_ids
}
