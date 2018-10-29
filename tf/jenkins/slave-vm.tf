resource "azurerm_public_ip" "jenkins-slave-0-public-ip" {
  name                         = "${module.namings.jenkins-slave-0-public-ip-name}"
  location                     = "${var.location}"
  depends_on                   = ["module.common-infra"]
  resource_group_name          = "${module.namings.resource-group-name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"
  domain_name_label            = "${var.prefix}-jenkins-slave-0"

  tags {
    environment = "${module.namings.environment-tag}"
  }
}

resource "azurerm_network_interface" "jenkins-slave-0-nic" {
  name                      = "${var.prefix}-jenkins-slave-0-nic"
  depends_on                = ["module.common-infra"]
  location                  = "${var.location}"
  resource_group_name       = "${module.namings.resource-group-name}"
  network_security_group_id = "${azurerm_network_security_group.jenkins-slave-sg.id}"

  ip_configuration {
    name                          = "${var.prefix}-jenkins-slave-0-ip-config"
    subnet_id                     = "${module.common-infra.it-subnet-id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost(module.common-infra.it-subnet-address-prefix,101)}"
    public_ip_address_id          = "${azurerm_public_ip.jenkins-slave-0-public-ip.id}"
  }
}

resource "azurerm_virtual_machine" "jenkins-slave-0" {
  name                    = "${var.prefix}-jenkins-slave-0"
  depends_on              = ["module.common-infra"]
  vm_size                 = "Standard_DS1_v2"
  location                = "${var.location}"
  resource_group_name     = "${module.namings.resource-group-name}"
  network_interface_ids   = ["${azurerm_network_interface.jenkins-slave-0-nic.id}"]
  storage_image_reference = ["${var.latest_ubuntu}"]

  storage_os_disk {
    name              = "${var.prefix}-jenkins-slave-0-osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "30"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys = [{
      path     = "/home/${var.ssh_user_username}/.ssh/authorized_keys"
      key_data = "${file(var.ssh_public_key_filename)}"
    }]
  }

  os_profile {
    computer_name  = "jenkins-slave-0"
    admin_username = "${var.ssh_user_username}"
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "jenkins-slave-0-data-disk-attach" {
  managed_disk_id    = "${azurerm_managed_disk.jenkins-slave-0-data-disk.id}"
  virtual_machine_id = "${azurerm_virtual_machine.jenkins-slave-0.id}"
  lun                = "1"
  caching            = "ReadWrite"
}