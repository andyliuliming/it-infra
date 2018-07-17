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

output "it-sg-name" {
  value = "${var.prefix}-it-sg"
}
