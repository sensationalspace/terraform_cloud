variable "stName" {
  type = string
}

variable "accountTier" {
  type    = string
  default = "Standard"
}

variable "accountReplication" {
  type    = string
  default = "LRS"
}

variable "location" {
  type = string
}

variable "rgName" {
  type = string
}

variable "snetID" {
  type = string
}

variable "vnetID" {
  type = string
}

variable "vnetName" {
  type = string
}

