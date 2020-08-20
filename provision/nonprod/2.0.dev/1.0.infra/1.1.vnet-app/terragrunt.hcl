terraform {
  source = "../../../../../Modules/vnet"
}

dependency "resource_group" {
  config_path = "../1.0.rg-app"

  mock_outputs = {
    resource_group_name = "test-group-id"
  }

  mock_outputs_allowed_terraform_commands = ["plan"]

}

locals {
  common_vars = yamldecode(file("${find_in_parent_folders("nonprod-common.yaml")}"))
}

inputs = {

  role                = "app"
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  cidr_range          = "${local.common_vars.CIDR[local.common_vars.location].DEV}.0.0/20"


  subnets = {
    app-example-sub = {
      cidr             = "${local.common_vars.CIDR[local.common_vars.location].DEV}.0.0/22",
      nsg-association  = "app-example-nsg"
      route-table      = ""
      service-endpoint = true
    },
    app-apim-sub = {
      cidr            = "${local.common_vars.CIDR[local.common_vars.location].DEV}.4.0/24",
      nsg-association = ""
      route-table     = ""
    },
  }

  serviceendpoint = ["Microsoft.EventHub", "Microsoft.Storage", "Microsoft.ContainerRegistry", "Microsoft.KeyVault"]

  nsgs = [
    {
      name = "app-example-nsg"
      rules = [
        {
          name                       = "Allow-Example"
          priority                   = 1000
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "${local.common_vars.CIDR[local.common_vars.location].DEV}.0.0/24"
          destination_address_prefix = "${local.common_vars.CIDR[local.common_vars.location].DEV}.2.0/24"
        },
        {
          name                       = "Allow-Kube-ClientIp"
          priority                   = 1001
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "1.1.1.1"
          destination_address_prefix = "*"
        },
      ]
    },
  ]
}


include {
  path = find_in_parent_folders()
}

