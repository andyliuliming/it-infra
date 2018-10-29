output "jenkins-master-public-ip" {
  value = "${azurerm_public_ip.jenkins-master-public-ip.ip_address}"
}
