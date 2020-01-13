variable "resource-group-name" {
  type = string
}

terraform {
    backend "azurerm" {
        resource_group_name  = var.resource-group-name
        storage_account_name = "storageaccountsiftertf"
        container_name       = "storagecontainersiftertf"
        key                  = "prod.terraform.tfstate"
    }
}