# Storage Account with VNet Network Rules
resource "azurerm_storage_account" "storage" {
  name                     = lower("${var.prefix}storacc")  # must be globally unique & lowercase
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.internal.id]
  }
}

# Private Endpoint for Storage Account (Optional for tighter integration)
resource "azurerm_private_endpoint" "storage_pe" {
  name                = "${var.prefix}-storage-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.internal.id

  private_service_connection {
    name                           = "${var.prefix}-storage-psc"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["blob"]  # You can also include "file", "queue", etc.
    is_manual_connection           = false
  }
}

# (Optional) Private DNS Zone for Storage Account (ensures proper name resolution)
resource "azurerm_private_dns_zone" "storage_zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_zone_link" {
  name                  = "${var.prefix}-dnslink"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = true
}

# (Optional) DNS Zone Group to link the Private Endpoint with the DNS zone
resource "azurerm_private_endpoint_dns_zone_group" "storage_dns" {
  name                 = "${var.prefix}-dzg"
  private_endpoint_id  = azurerm_private_endpoint.storage_pe.id
  private_dns_zone_ids = [azurerm_private_dns_zone.storage_zone.id]
}
