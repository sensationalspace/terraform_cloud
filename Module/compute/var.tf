variable "vmName" {
  type = string
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

variable "vmSize" {
  type = string
  default = "Standard_DS1_v2"
}
