resource "azurerm_managed_disk" "jenkins-master-data-disk" {
  name                 = "${module.namings.jenkins-master-data-disk-name}"
  depends_on           = ["module.common-infra"]
  location             = "${var.location}"
  resource_group_name  = "${module.namings.resource-group-name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}

resource "azurerm_managed_disk" "jenkins-slave-0-data-disk" {
  name                 = "${module.namings.jenkins-slave-0-data-disk-name}"
  depends_on           = ["module.common-infra"]
  location             = "${var.location}"
  resource_group_name  = "${module.namings.resource-group-name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}