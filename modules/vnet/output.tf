output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The Name of the newly created vNet"
  value       = azurerm_virtual_network.this.name
}

output "resource_group_name" {
  description = "The Name of the resource group"
  value       = azurerm_virtual_network.this.resource_group_name
}

output "vnet_location" {
  description = "The location of the newly created vNet"
  value       = azurerm_virtual_network.this.location
}

output "vnet_address_space" {
  description = "The address space of the newly created vNet"
  value       = azurerm_virtual_network.this.address_space
}

output "vnet_subnets" {
  description = "The ids of subnets created inside the newl vNet"
  value       = azurerm_subnet.this
}

output "nsgs" {
  description = "The ids of subnets created inside the newl vNet"
  value       = azurerm_network_security_group.this
}

output "route_tables" {
  description = "Created routetables"
  value       = azurerm_route_table.this
}

output "nic_id" {
  description = "id of nic"
  value       = azurerm_network_interface.this
}

output "public_ip_address" {
  description = "public ip"
  value       = azurerm_public_ip.this
}
