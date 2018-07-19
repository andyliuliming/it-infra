variable "prefix" {
  type = "string"
}

variable "location" {
  type    = "string"
  default = "westus"
}

variable "network_cidr" {
  default = "10.0.0.0/16"
}

variable "ssh_user_username" {
  type    = "string"
  default = "admin"
}

variable "latest_ubuntu" {
  type = "map"

  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }
}

variable "ssh_public_key_filename" {
  type = "string"
}
