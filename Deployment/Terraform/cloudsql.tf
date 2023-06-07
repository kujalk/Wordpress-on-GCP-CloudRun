resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
  lower   = true
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "google_sql_database" "database" {
  name     = "${var.prefix}-db-${random_string.random.result}"
  instance = google_sql_database_instance.main.name
}

resource "google_sql_database_instance" "main" {

  depends_on          = [google_service_networking_connection.private_vpc_connection]
  name                = "${var.prefix}-db-instance"
  database_version    = "MYSQL_8_0"
  region              = "us-central1"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.custom-vpc.id
      enable_private_path_for_google_cloud_services = true
    }
  }
}

resource "google_sql_user" "users" {
  name     = "admin"
  instance = google_sql_database_instance.main.name
  password = random_password.password.result
}