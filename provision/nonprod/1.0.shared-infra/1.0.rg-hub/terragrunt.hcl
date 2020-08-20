terraform {
  source = "../../../../modules/resource_group"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  role = "hub"
}
