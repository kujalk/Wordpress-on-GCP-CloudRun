
//service account to be assigned to cloudrun
resource "google_service_account" "sa" {
  account_id   = "${var.prefix}-cloudrun-sa"
  display_name = "${var.prefix}-cloudrun-sa"
}