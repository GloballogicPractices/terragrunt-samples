provider "azurerm" {
  version = ">= 1.38.9"
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = local.rg_name
  location = var.location
  tags     = local.rg_tags
}
