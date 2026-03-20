include "root" {
  path = find_in_parent_folders()
}

dependency "_global" {
  config_path = "../_global"
}