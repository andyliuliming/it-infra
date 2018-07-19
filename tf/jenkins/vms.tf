resource "azurerm_public_ip" "jenkins-public-ip" {
  name                         = "${var.prefix}-jenkins-ip"
  location                     = "${var.location}"
  depends_on                   = ["module.common-infra"]
  resource_group_name          = "${module.namings.resource-group-name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"
  domain_name_label            = "${var.prefix}-jenkins"

  tags {
    environment = "${module.namings.environment-tag}"
  }
}

// BOSH bastion host
resource "azurerm_network_interface" "jenkins-nic" {
  name                      = "${var.prefix}-jenkins-nic"
  depends_on                = ["module.common-infra"]
  location                  = "${var.location}"
  resource_group_name       = "${module.namings.resource-group-name}"
  network_security_group_id = "${module.common-infra.it-security-group-id}"

  ip_configuration {
    name                          = "${var.prefix}-jenkins-ip-config"
    subnet_id                     = "${module.common-infra.it-subnet-id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost(module.common-infra.it-subnet-address-prefix,100)}"
    public_ip_address_id          = "${azurerm_public_ip.jenkins-public-ip.id}"
  }
}

resource "azurerm_virtual_machine" "jenkins" {
  name                    = "${var.prefix}-jenkins"
  depends_on              = ["module.common-infra"]
  vm_size                 = "Standard_D1_v2"
  location                = "${var.location}"
  resource_group_name     = "${module.namings.resource-group-name}"
  network_interface_ids   = ["${azurerm_network_interface.jenkins-nic.id}"]
  storage_image_reference = ["${var.latest_ubuntu}"]

  storage_os_disk {
    name              = "osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "50"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys = [{
      path     = "/home/${var.ssh_user_username}/.ssh/authorized_keys"
      key_data = "${file(var.ssh_public_key_filename)}"
    }]
  }

  os_profile {
    computer_name  = "jenkins"
    admin_username = "${var.ssh_user_username}"
  }
}
