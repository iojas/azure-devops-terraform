variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_storage_account" "example" {
  name                = var.storage_account_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_container_registry" "acr" {
  name                     = "armcontainertestsifter"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  sku                      = "Premium"
  admin_enabled            = false
  georeplication_locations = ["East US", "West Europe"]
}

resource "azurerm_storage_container" "example" {
  name                  = "storagecontainersiftertf"
  storage_account_name  = data.azurerm_storage_account.example.name
  container_access_type = "private"
}
