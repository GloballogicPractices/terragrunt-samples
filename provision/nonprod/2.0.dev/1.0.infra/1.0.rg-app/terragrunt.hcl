terraform {
  source = "../../../../../Modules/resource_group"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  role = "app"
}
