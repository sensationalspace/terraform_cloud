output "rgName" {
  value = azurerm_resource_group.rg.name
}

output "rgLocation" {
  value = azurerm_resource_group.rg.location
}

output "snet-b" {
  value = azurerm_subnet_network_security_group_association.nsgSnet-b.id
}

output "snet-e" {
  value = azurerm_subnet_network_security_group_association.nsgSnet-e.id
}

output "snet-w" {
  value = azurerm_subnet_network_security_group_association.nsgSnet-w.id
}

output "vnetID" {
  value = azurerm_virtual_network.vnet.id
}
