output "jenkins-public-ip" {
  value = "${azurerm_public_ip.jenkins-public-ip.ip_address}"
}
