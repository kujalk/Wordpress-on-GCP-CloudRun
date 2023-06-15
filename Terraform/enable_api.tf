//enabling the apis required for the project
resource "google_project_service" "vpcaccess" {
  service                    = "vpcaccess.googleapis.com"
  project                    = var.project-id
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "sqlcomponent" {
  service                    = "sql-component.googleapis.com"
  project                    = var.project-id
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "servicenetworking" {
  service                    = "servicenetworking.googleapis.com"
  project                    = var.project-id
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "secretmanager" {
  service                    = "secretmanager.googleapis.com"
  project                    = var.project-id
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "cloudresourcemanager" {
  service                    = "cloudresourcemanager.googleapis.com"
  project                    = var.project-id
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "iam" {
  service                    = "iam.googleapis.com"
  project                    = var.project-id
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "redis" {
  service                    = "redis.googleapis.com"
  project                    = var.project-id
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "sqladmin" {
  service                    = "sqladmin.googleapis.com"
  project                    = var.project-id
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "cloudrun" {
  service                    = "run.googleapis.com"
  project                    = var.project-id
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "cloudbuild" {
  service                    = "cloudbuild.googleapis.com"
  project                    = var.project-id
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "containerregistry" {
  service                    = "containerregistry.googleapis.com"
  project                    = var.project-id
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "artifactregistry" {
  service                    = "artifactregistry.googleapis.com"
  project                    = var.project-id
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "time_sleep" "wait_for_allapis" {
  create_duration = "120s"
  depends_on = [google_project_service.vpcaccess,
    google_project_service.sqlcomponent,
    google_project_service.servicenetworking,
    google_project_service.secretmanager,
    google_project_service.cloudresourcemanager,
    google_project_service.iam,
    google_project_service.redis,
    google_project_service.sqladmin,
    google_project_service.cloudrun,
    google_project_service.cloudbuild,
    google_project_service.containerregistry,
    google_project_service.artifactregistry
  ]
}