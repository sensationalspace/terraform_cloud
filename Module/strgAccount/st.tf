resource "azurerm_storage_account" "this" {
  name                     = var.stName #"${var.prefix}saeftgbtgsd"
  location                 = var.location
  resource_group_name      = var.rgName
  account_tier             = var.accountTier
  account_replication_type = var.accountReplication

  tags = {
    environment = "staging"
  }
}
