resource "google_redis_instance" "cache" {

  depends_on     = [google_service_networking_connection.private_vpc_connection]
  name           = "${var.prefix}-rediscache-${random_string.random.result}"
  tier           = "BASIC" #"STANDARD_HA"
  memory_size_gb = 1

  region      = "us-central1"
  location_id = "us-central1-a"
  #alternative_location_id = "us-central1-f"

  authorized_network = google_compute_network.custom-vpc.id

  redis_version     = "REDIS_6_X"
  display_name      = "${var.prefix} redis cache"
  reserved_ip_range = "10.7.0.0/28"

  labels = {
    my_key    = "creator"
    other_key = "terraform"
  }
}