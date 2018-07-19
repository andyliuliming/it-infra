output "it-security-group-id" {
  value = "${azurerm_network_security_group.it.id}"
}

output "it-subnet-id" {
  value = "${azurerm_subnet.it-subnet.id}"
}

output "it-subnet-address-prefix" {
  value = "${azurerm_subnet.it-subnet.address_prefix}"
}
