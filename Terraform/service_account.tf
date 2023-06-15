resource "random_string" "wpbucket" {
  length  = 12
  special = false
  upper   = false
  lower   = true
}

resource "google_storage_bucket" "wpbucket" {
  name                        = "${var.prefix}-${random_string.wpbucket.result}"
  location                    = "us-central1"
  force_destroy               = true
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

resource "google_project_iam_member" "wpstorage_svc" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.sa.email}"
  role    = "roles/storage.admin"

  condition {
    title       = "Access to ${google_storage_bucket.wpbucket.name}"
    description = "restricted access to storage bucket ${google_storage_bucket.wpbucket.name}"
    expression  = "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.wpbucket.name}\")"

  }
}

output "bucket_name_wp_supercache" {
  value = google_storage_bucket.wpbucket.name
}

//service account to be assigned to cloudrun
resource "google_service_account" "sa" {
  depends_on   = [time_sleep.wait_for_allapis]
  account_id   = "${var.prefix}-cloudrun-sa"
  display_name = "${var.prefix}-cloudrun-sa"
}