terraform {
  backend "s3" {
    bucket = var.state_bucket
    region = var.region
    key    = "dev/_global/terraform.tfstate"
  }
}

output "git_repository_owner_konstantin_tarletski_name" {
  value = "konstantinTarletski"
}

output "environment" {
  value = "dev"
}

output "default_tags" {
  value = {
    Manufactor = "terraform",
    Design     = "tarlekon",
    Source     = "module"
  }
}
