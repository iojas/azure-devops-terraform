resource "azurerm_resource_group" "rg" {
  name     = "ojas-test"
  location = "Central US"
}

resource "azurerm_container_registry" "acr" {
  name                     = "ojassiftertf"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Premium"
  admin_enabled            = false
  georeplication_locations = ["East US", "West Europe"]
}

resource "azurerm_storage_account" "example" {
  name                     = "storageaccountsiftertf"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}


resource "azurerm_storage_container" "example" {
  name                  = "storagecontainersiftertf"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

//terraform {
//  backend "azurerm" {
//    resource_group_name  = azurerm_resource_group.rg.name
//    storage_account_name = azurerm_storage_account.example.name
//    container_name       = azurerm_storage_container.example.name
//    key                  = "prod.terraform.tfstate"
//  }
//}