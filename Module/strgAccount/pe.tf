
resource "azurerm_private_endpoint" "storage_account" {
  name                = "${var.stName}-pe-sa"
  location                 = var.location
  resource_group_name      = var.rgName
  subnet_id           = var.snetID

  private_service_connection {
    name                           = "${var.stName}-pe-sa"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = {
    environment = "staging"
  }
}

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.rgName
  tags = {
    environment = "staging"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "${azurerm_private_dns_zone.blob.name}-${var.vnetName}"
  resource_group_name   = var.rgName
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = var.vnetID
}
