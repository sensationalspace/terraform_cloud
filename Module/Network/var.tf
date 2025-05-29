variable "prefix" {
  type    = string
  default = "terra"
}

variable "rgName" {
  type = string
}

variable "rgLocation" {
  type = string
  default = "CentralIndia"
}

variable "vnetName" {
  type = string
}

variable "snetName" {
  type = list
}
variable "vnetAddressSpace" {
  type = list
}

variable "snetAddressSpace" {
  type = list
}

variable "networkPolicy" {
  type = bool
  default = true
}
