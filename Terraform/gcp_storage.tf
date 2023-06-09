resource "random_string" "bucket" {
  length  = 12
  special = false
  upper   = false
  lower   = true
}

resource "google_storage_bucket" "bucket" {
  name                        = "${var.prefix}-${random_string.bucket.result}"
  location                    = "us-central1"
  force_destroy               = true
  storage_class               = "STANDARD"
  uniform_bucket_level_access = false
}

resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.bucket.name
  role   = "READER"
  entity = "allUsers"
}


//service account for cloud storage
resource "google_service_account" "storagesvc" {
  account_id   = "${var.prefix}-storage-accessor"
  display_name = "${var.prefix} storage accessor for ${google_storage_bucket.bucket.name}"
}


resource "google_project_iam_member" "storage_svc" {
  project = var.project-id
  member  = "serviceAccount:${google_service_account.storagesvc.email}"
  role    = "roles/storage.admin"

  condition {
    title       = "Access to ${google_storage_bucket.bucket.name}"
    description = "restricted access to storage bucket ${google_storage_bucket.bucket.name}"
    expression  = "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.bucket.name}\")"

  }
}

resource "google_service_account_key" "storagekey" {
  service_account_id = google_service_account.storagesvc.name
}

resource "local_file" "key_file" {
  filename = "svc.json"
  content  = base64decode(google_service_account_key.storagekey.private_key)
}

output "bucket_name" {
  value = google_storage_bucket.bucket.name
}