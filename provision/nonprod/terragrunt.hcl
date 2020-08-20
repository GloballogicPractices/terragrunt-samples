remote_state {
  backend = "azurerm"
  
  generate = {
    path      = "main.tf"
    if_exists = "overwrite_terragrunt"
  }
  
  config = {
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    resource_group_name  = "reged2020"
    storage_account_name = "regedsa2020"
    container_name       = "tfstate"
  }
}


inputs = merge(
  yamldecode(
    file("${find_in_parent_folders("env.yaml")}"),
  ),

  yamldecode(
    file("${find_in_parent_folders("nonprod-common.yaml")}"),
  ),

  {
    tags = "${map(
      "Cost_center", "reged",
    )}",
  },

)
