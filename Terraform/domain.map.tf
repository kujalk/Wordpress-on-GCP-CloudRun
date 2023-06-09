# resource "google_cloud_run_domain_mapping" "default" {
#   location = "us-central1"
#   name     = "verified-domain.com"

#   metadata {
#     namespace = var.project-id
#   }

#   spec {
#     route_name = google_cloud_run_v2_service.default.name
#   }
# }