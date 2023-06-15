resource "google_vpc_access_connector" "connector" {
  depends_on = [time_sleep.wait_for_allapis]
  name       = "${var.prefix}-connector"
  subnet {
    name = google_compute_subnetwork.vpc-connector.name
  }
  machine_type  = "e2-standard-4"
  min_instances = 2
  max_instances = 3
  region        = "us-central1"
}