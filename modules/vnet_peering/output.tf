output "vnet_peering_first_id" {
  description = "The first peering id"
  value       = azurerm_virtual_network_peering.first-to-second
}

output "vnet_peering_second_id" {
  description = "The second peering id"
  value       = azurerm_virtual_network_peering.second-to-first
}


