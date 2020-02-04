variable "location" {
  type = string
}

variable "POSTGRES_USERNAME" {}
variable "POSTGRES_PASSWORD" {}
variable "DB_SERVER_NAME" {}

resource "azurerm_postgresql_server" "example" {
  name                = var.DB_SERVER_NAME
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "B_Gen5_2"

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
    auto_grow             = "Enabled"
  }

  administrator_login          = var.POSTGRES_USERNAME
  administrator_login_password = var.POSTGRES_PASSWORD
  version                      = "9.5"
  ssl_enforcement              = "Enabled"
}


resource "azurerm_postgresql_firewall_rule" "example" {
  name                = "openrule"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.example.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}