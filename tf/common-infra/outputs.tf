output "it-subnet-id" {
  value = "${azurerm_subnet.it-subnet.id}"
}

output "it-subnet-address-prefix" {
  value = "${azurerm_subnet.it-subnet.address_prefix}"
}
