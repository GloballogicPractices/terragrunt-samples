provider "azurerm" {
  version = ">= 1.38.9"
  features {}
}

module "service_bus" {
  source = "innovationnorway/service-bus/azurerm"

  name = local.sb_name
  resource_group_name = var.resource_group_name
  topics = var.topics
}
