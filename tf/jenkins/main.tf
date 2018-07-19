module "namings" {
  source = "../namings"
  prefix = "${var.prefix}"
}

module "common-infra" {
  source       = "../common-infra"
  prefix       = "${var.prefix}"
  location     = "${var.location}"
  network_cidr = "${var.network_cidr}"
}
