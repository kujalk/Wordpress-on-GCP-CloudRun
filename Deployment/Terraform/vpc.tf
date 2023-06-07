resource "google_compute_network" "custom-vpc" {
  name                    = "${var.prefix}-${random_string.random.result}-vpc" #Added random string, because it not possible to recreate the same vpc name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.prefix}-us-central-subnetwork"
  ip_cidr_range = "10.5.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.custom-vpc.id
}

resource "google_compute_subnetwork" "vpc-connector" {
  name          = "${var.prefix}-vpc-connector-subnetwork"
  ip_cidr_range = "10.6.0.0/28"
  region        = "us-central1"
  network       = google_compute_network.custom-vpc.id
}

resource "google_compute_global_address" "private_ip_address" {

  name          = "private-gcp-service-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.custom-vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.custom-vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}