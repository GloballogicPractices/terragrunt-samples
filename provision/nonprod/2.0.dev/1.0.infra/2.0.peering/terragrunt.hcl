terraform {
  source = "../../../../../Modules/vnet_peering"
}


dependency "vnet_app" {
  config_path = "../1.1.vnet-app"

  mock_outputs = {
    vnet_name           = "vnetappname"
    resource_group_name = "rgappname"
    vnet_id             = "/subscriptions/***/resourceGroups/test/providers/Microsoft.Network/virtualNetworks/vnetappname"

  }

  mock_outputs_allowed_terraform_commands = ["plan"]
}



dependency "vnet_hub" {
  config_path = "../../../1.0.shared-infra/1.1.vnet-hub"

  mock_outputs = {
    vnet_name           = "vnethubname"
    resource_group_name = "rghubname"
    vnet_id             = "/subscriptions/asd/resourceGroups/test/providers/Microsoft.Network/virtualNetworks/vnethubname"

  }

  mock_outputs_allowed_terraform_commands = ["plan"]
}




inputs = {

  role = "peering"


  peeringvnets = {
    hubtoapp = {
      network1_vnet_name = dependency.vnet_hub.outputs.vnet_name
      network2_vnet_name = dependency.vnet_app.outputs.vnet_name
      network1_vnet_id   = dependency.vnet_hub.outputs.vnet_id
      network2_vnet_id   = dependency.vnet_app.outputs.vnet_id
      network1_rg        = dependency.vnet_hub.outputs.resource_group_name
      network2_rg        = dependency.vnet_app.outputs.resource_group_name
    }
  }

  tags = {
    role = "peering"

  }
}

include {
  path = find_in_parent_folders()
}
