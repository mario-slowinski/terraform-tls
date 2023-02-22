data "azurerm_client_config" "current" {}

resource "random_password" "pfx" {
  length  = 16
  special = false
}
