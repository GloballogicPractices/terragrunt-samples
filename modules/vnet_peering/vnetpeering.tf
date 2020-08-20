

resource "azurerm_virtual_network_peering" "first-to-second" {
  for_each                     = var.peeringvnets
  name                         = format("%s%s", local.vnetpeer_first, each.key)
  resource_group_name          = lookup(each.value, "network1_rg")
  virtual_network_name         = lookup(each.value, "network1_vnet_name")
  remote_virtual_network_id    = lookup(each.value, "network2_vnet_id")
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  use_remote_gateways          = var.use_remote_gateways
}

resource "azurerm_virtual_network_peering" "second-to-first" {
  for_each                     = var.peeringvnets
  name                         = format("%s%s", local.vnetpeer_second, each.key)
  resource_group_name          = lookup(each.value, "network2_rg")
  virtual_network_name         = lookup(each.value, "network2_vnet_name")
  remote_virtual_network_id    = lookup(each.value, "network1_vnet_id")
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  use_remote_gateways          = var.use_remote_gateways
}
