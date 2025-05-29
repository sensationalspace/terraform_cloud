
#######################################
#          VIRTUAL MACHINE            #
#######################################
resource "azurerm_virtual_machine" "vm" {
  name                  = var.vmName
  location            = var.location
  resource_group_name = var.rgName
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vmSize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vmName}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "tfadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "staging"
  }
}
