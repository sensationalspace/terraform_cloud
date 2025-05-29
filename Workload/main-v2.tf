#######################################
#         RESOURCE GROUP              #
#######################################
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-resourcegroup"
  location = "Central India"
}
##Network Module
module "network" {
  source           = "../Module/Network"
  rgName           = "${var.prefix}-resourcegroup"
  vnetName         = local.vnetName
  vnetAddressSpace = local.vnetAddressSpace
  snetName         = local.snetName
  snetAddressSpace = local.snetAddressSpace
}
##Compute Module
module "compute" {
  source     = "../Module/compute"
  vmName     = "${var.prefix}-vm"
  rgName     = module.network.rgName
  location   = module.network.rgLocation
  snetID     = module.network.snet-w
  depends_on = [module.network]
}

module "stoargeAccount" {
  source     = "../Module/strgAccount"
  stName     = "${var.prefix}saeftgbtgsd"
  rgName     = module.network.rgName
  location   = module.network.rgLocation
  vnetName   = local.vnetName
  vnetID     = module.network.vnetID
  snetID     = module.network.snet-e
  depends_on = [module.network]
}
