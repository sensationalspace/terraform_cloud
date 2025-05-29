locals {
  vnetAddressSpace = "10.0.0.0/16"
  

  snetAddressSpace = [
    ["10.0.1.0/24"],
    ["10.0.2.0/24"],
    ["10.0.3.0/24"]
  ]
  vnetName = "${var.prefix}-vnet"

  snetName = [
    "${var.prefix}-workload",
    "${var.prefix}-endpoints",
    "${var.prefix}-bastion"
  ]
}