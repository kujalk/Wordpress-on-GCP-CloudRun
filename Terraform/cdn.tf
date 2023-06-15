# resource "google_compute_global_address" "glb" {
#   name = "${var.prefix}-global-ip"
# }

# resource "google_compute_global_forwarding_rule" "paas-monitor" {
#   name       = "${var.prefix}-forwarding-rule"
#   ip_address = google_compute_global_address.glb.address
#   port_range = "80"
#   target     = google_compute_target_http_proxy.glb.self_link
# }

# resource "google_compute_target_http_proxy" "glb" {
#   name    = "${var.prefix}-http-proxy"
#   url_map = google_compute_url_map.glb.self_link
# }

# resource "google_compute_url_map" "glb" {
#   name            = "${var.prefix}-url"
#   default_service = google_compute_backend_service.backend.self_link
# }

# resource "google_compute_region_network_endpoint_group" "cloudrun_neg_1" {
#   name                  = "${var.prefix}-endpoint-group"
#   network_endpoint_type = "SERVERLESS"
#   region                = "us-central1"
#   cloud_run {
#     service = google_cloud_run_v2_service.default.name
#   }
# }


# resource "google_compute_backend_service" "backend" {
#   name = "${var.prefix}-backend"

#   enable_cdn              = true
#   protocol    = "HTTP"
#   port_name   = "http"
#   timeout_sec = 30

#   backend {
#     group = google_compute_region_network_endpoint_group.cloudrun_neg_1.id
#   }
# }

# output "cdn-ip"{
#     value = google_compute_global_address.glb.address
# }

