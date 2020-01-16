terraform {
    backend "azurerm" {
        resource_group_name  = "CLIGroupForArm"
        storage_account_name = "armstoragetestsifter"
        container_name       = "armstoragecontainer"
        key                  = "terraform.tfstate"
    }
}