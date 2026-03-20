include "root" {
  path = find_in_parent_folders()
}

dependency "alb" {
  config_path = "../alb"
}

dependency "ecr" {
  config_path = "../ecr_and_roles"
}