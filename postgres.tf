variable "location" {
  type = string
}

resource "azurerm_postgresql_server" "example" {
  name                = "postgresql-server-2"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "B_Gen5_2"

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
    auto_grow             = "Enabled"
  }

  administrator_login          = "postgresadmin"
  administrator_login_password = "P@$sVv0R1D"
  version                      = "9.5"
  ssl_enforcement              = "Enabled"
}