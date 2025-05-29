
#######################################
#              VARIABLES              #
#######################################
variable "prefix" {
  type    = string
  default = "terra"
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

