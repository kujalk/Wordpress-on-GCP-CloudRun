resource "google_secret_manager_secret" "secret-basic" {
  depends_on      = [time_sleep.wait_for_allapis]
  secret_id = "${var.prefix}-dbsecret-${random_string.random.result}"

  labels = {
    label = "${var.prefix}-dbsecret-${random_string.random.result}"
  }

  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "secret-version-basic" {
  secret      = google_secret_manager_secret.secret-basic.id
  secret_data = random_password.password.result
}

resource "google_secret_manager_secret_iam_binding" "sa_secret_binding" {
  project   = var.project-id
  secret_id = google_secret_manager_secret.secret-basic.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.sa.email}",
  ]
}