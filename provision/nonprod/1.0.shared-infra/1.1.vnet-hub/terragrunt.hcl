terraform {
  source = "../../../../Modules/vnet"
}

dependency "resource_group" {
  config_path = "../1.0.rg-hub"

  mock_outputs = {
    resource_group_name = "test-group-id"
  }

  mock_outputs_allowed_terraform_commands = ["plan"]

}

locals {
  common_vars = yamldecode(file("${find_in_parent_folders("nonprod-common.yaml")}"))
}

inputs = {
  role                = "hub"
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  cidr_range          = "${local.common_vars.CIDR[local.common_vars.location].HUB}.0.0/20"

  subnets = {
    hub-jumbox-mgmt-sub = {
      cidr            = "${local.common_vars.CIDR[local.common_vars.location].HUB}.0.128/26",
      nsg-association = ""
      route-table     = ""
    },
    hub-untrust-sub = {
      cidr             = "${local.common_vars.CIDR[local.common_vars.location].HUB}.1.0/24",
      nsg-association  = "hub-untrust-nsg"
      route-table      = "hub-out-rtb"
      service-endpoint = true
    },
    hub-trust-sub = {
      cidr            = "${local.common_vars.CIDR[local.common_vars.location].HUB}.2.0/24",
      nsg-association = ""
      route-table     = ""
    },
    GatewaySubnet = {
      cidr            = "${local.common_vars.CIDR[local.common_vars.location].HUB}.5.0/25",
      nsg-association = ""
      route-table     = ""
    },
    AzureBastionSubnet = {
      cidr            = "${local.common_vars.CIDR[local.common_vars.location].HUB}.5.128/26",
      nsg-association = "hub-bastion-nsg"
      route-table     = ""
    }
    AzureFirewallSubnet = {
      cidr            = "${local.common_vars.CIDR[local.common_vars.location].HUB}.6.0/25",
      nsg-association = ""
      route-table     = ""
    }
  }

  serviceendpoint = ["Microsoft.ContainerRegistry", "Microsoft.EventHub"]

  publicips = {
    publicipapp = {
      allocation_method = "Dynamic"
      domain_name_label = "${local.common_vars.application}app"
    }
    publicipbh = {
      allocation_method = "Static"
      domain_name_label = "${local.common_vars.application}bh"
      publicipsku       = "Standard"
    }
    publicipfw = {
      allocation_method = "Static"
      domain_name_label = "${local.common_vars.application}fw"
      publicipsku       = "Standard"

    }
  }

  nics = {
    nic-inbound-untrust = {
      name                          = "ipconfiginbounduntrust"
      subnet_id                     = "hub-untrust-sub"
      private_ip_address_allocation = "Static"
      asg_id                        = ""
      private_ip_address            = "${local.common_vars.CIDR[local.common_vars.location].HUB}.1.4"
    }
    nic-inbound-trust = {
      name                          = "ipconfiginboundtrust"
      subnet_id                     = "hub-trust-sub"
      private_ip_address_allocation = "Static"
      asg_id                        = ""
      private_ip_address            = "${local.common_vars.CIDR[local.common_vars.location].HUB}.2.4"
    }
    nic-outbound-untrust = {
      name                          = "ipconfigoutbounduntrust"
      subnet_id                     = "hub-untrust-sub"
      private_ip_address_allocation = "Static"
      asg_id                        = ""
      private_ip_address            = "${local.common_vars.CIDR[local.common_vars.location].HUB}.1.5"
    }
    nic-outbound-trust = {
      name                          = "ipconfigoutboundtrust"
      subnet_id                     = "hub-trust-sub"
      private_ip_address_allocation = "Static"
      asg_id                        = ""
      private_ip_address            = "${local.common_vars.CIDR[local.common_vars.location].HUB}.2.5"
    }
    nic-jumpbox-vm = {
      name                          = "ipconfigjumpboxvm"
      subnet_id                     = "hub-jumbox-mgmt-sub"
      private_ip_address_allocation = "Static"
      asg_id                        = ""
      private_ip_address            = "${local.common_vars.CIDR[local.common_vars.location].HUB}.0.140"
    }
  }

  nsgs = [
    {
      name = "hub-bastion-nsg"
      rules = [
        {
          name                       = "allow-443"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "allow-4443-gateway"
          priority                   = 101
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "4443"
          source_address_prefix      = "GatewayManager"
          destination_address_prefix = "*"
        },
        {
          name                       = "allow-443-gateway"
          priority                   = 102
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "GatewayManager"
          destination_address_prefix = "*"
        },
        {
          name                       = "deny-all-in"
          priority                   = 1001
          direction                  = "Inbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },

        {
          name                       = "allow-22-Outbound"
          priority                   = 100
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = "*"
          destination_address_prefix = "VirtualNetwork"
        },
        {
          name                       = "allow-3389-outbound"
          priority                   = 101
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "3389"
          source_address_prefix      = "*"
          destination_address_prefix = "VirtualNetwork"
        },
        {
          name                       = "allow-azurecloud-outbound"
          priority                   = 120
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "AzureCloud"
        },
      ]
    },
    {
      name = "hub-untrust-nsg"
      rules = [
        {
          name                       = "Allow-Port-80"
          priority                   = 1001
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "80"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "Allow-Port-443"
          priority                   = 1002
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
      ]
    },
  ]

  routetables = [
    {
      name = "hub-out-rtb"
      routes = [
        {
          name                   = "rt-from-hub-to-apim-devqauat"
          address_prefix         = "${local.common_vars.CIDR[local.common_vars.location].DEV}.4.0/24"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "${local.common_vars.CIDR[local.common_vars.location].HUB}.4.4"

        },
        {
          name                   = "rt-from-hub-to-kube-devqauat"
          address_prefix         = "${local.common_vars.CIDR[local.common_vars.location].DEV}.0.0/22"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "${local.common_vars.CIDR[local.common_vars.location].HUB}.4.4"
        },
      ]
    },
  ]
}



include {
  path = find_in_parent_folders()
}
