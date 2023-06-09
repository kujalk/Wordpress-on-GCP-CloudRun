
//service account to be assigned to cloudrun
resource "google_service_account" "sa" {
  depends_on   = [time_sleep.wait_for_allapis]
  account_id   = "${var.prefix}-cloudrun-sa"
  display_name = "${var.prefix}-cloudrun-sa"
}