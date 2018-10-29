output "resource-group-name" {
  value = "${var.prefix}-rg"
}

output "environment-tag" {
  value = "${var.prefix}-env"
}

output "vnet-name" {
  value = "${var.prefix}-vnet"
}

output "it-subnet-name" {
  value = "${var.prefix}-it-subnet"
}

output "jenkins-master-public-ip-name" {
  value = "${var.prefix}-jenkins-master-ip"
}
output "jenkins-slave-0-public-ip-name" {
  value = "${var.prefix}-jenkins-slave-0-ip"
}

output "jenkins-master-sg-name" {
  value = "${var.prefix}-jenkins-master-sg"
}

output "jenkins-slave-sg-name" {
  value = "${var.prefix}-jenkins-slave-sg"
}

output "jenkins-master-data-disk-name" {
  value = "${var.prefix}-jenkins-master-data"
}

output "jenkins-slave-0-data-disk-name" {
  value = "${var.prefix}-jenkins-slave-0-data"
}
