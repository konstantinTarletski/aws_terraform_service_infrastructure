include "root" {
  path = find_in_parent_folders()
}

dependency "alb" {
  config_path = "../alb"
}

dependency "ecr" {
  config_path = "../ecr_and_roles"
}

dependency "_shared" {
  config_path = "../_shared"
}

dependency "_global" {
  config_path = "../../_global"
}