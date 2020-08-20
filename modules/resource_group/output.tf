output "resource_group_name" {
  description = "Name of created resource group"
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "Name of created resource group"
  value       = azurerm_resource_group.this.id
}

output "resource_group_location" {
  description = "location of created resource group"
  value       = azurerm_resource_group.this.location
}
