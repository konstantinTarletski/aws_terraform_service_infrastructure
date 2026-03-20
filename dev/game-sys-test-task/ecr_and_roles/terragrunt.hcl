include "root" {
  path = find_in_parent_folders()
}

dependency "_shared" {
  config_path = "../_shared"
}

dependency "_global" {
  config_path = "../../_global"
}