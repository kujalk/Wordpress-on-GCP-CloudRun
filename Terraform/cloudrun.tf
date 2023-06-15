resource "google_cloud_run_v2_service" "default" {
  name     = "${var.prefix}-app"
  location = "us-central1"
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {

    execution_environment            = "EXECUTION_ENVIRONMENT_GEN2"
    service_account                  = google_service_account.sa.email
    max_instance_request_concurrency = var.max_concurrency
    timeout                          = "30s"
    scaling {
      max_instance_count = var.max_instance_count
      min_instance_count = var.min_instance_count
    }

    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress    = "PRIVATE_RANGES_ONLY"
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.main.connection_name]
      }
    }

    containers {
      image = "us-central1-docker.pkg.dev/${var.project-id}/${var.prefix}-repo/customwordpress:latest"
      ports {
        container_port = 80
      }

      resources {
        limits = {
          # CPU usage limit
          cpu = var.max_cpu # 1 vCPU

          # Memory usage limit (per container)
          memory = var.max_memory
        }
      }
      env {
        name  = "MNT_BUCKET"
        value = google_storage_bucket.wpbucket.name
      }
      env {
        name  = "DB_NAME"
        value = google_sql_database.database.name
      }
      env {
        name  = "DB_USER"
        value = "admin"
      }
      env {
        name  = "DB_HOST"
        value = google_sql_database_instance.main.ip_address.0.ip_address
      }
      env {
        name  = "WP_REDIS_HOST"
        value = google_redis_instance.cache.host
      }
      env {
        name = "DB_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.secret-basic.secret_id
            version = "1"
          }
        }
      }
      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
  depends_on = [google_secret_manager_secret_version.secret-version-basic]
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_v2_service.default.location
  service  = google_cloud_run_v2_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}