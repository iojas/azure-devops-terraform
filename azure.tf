variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "container_name" {
  type = string
}

# module "ingress_kube_cluster" {
#   source = "./ingress-kube/"
#   aks_service_principal_app_id="d90eb49b-6418-4335-acdb-f3d74c44b0ab"
#   aks_service_principal_client_secret="f715d4b6-429a-4cd9-a54a-e02042d66097"
#   aks_service_principal_object_id="86266283-c3fe-4557-8440-d372fe4e525d"
#   resource_group_name="CLIGroupForArm"
#   location="westus"
# }

module "backend" {
  source = "./terraform-backend/"
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_storage_account" "example" {
  name                = var.storage_account_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_container_registry" "acr" {
  name                     = var.container_name
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  sku                      = "Premium"
  admin_enabled            = false
  georeplication_locations = ["East US", "West Europe"]
}
