resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-central1"
  repository_id = "${var.prefix}-repo"
  description   = "${var.prefix} docker repository"
  format        = "DOCKER"
}

locals {
  is_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true
}

resource "null_resource" "script" {

  depends_on = [time_sleep.wait_for_allapis, local_file.key_file]
  provisioner "local-exec" {
    command = <<EOT

    cp ../svc.json svc.json
    sudo chmod a+rw svc.json
    sudo chmod -R 777 wp-content/

    gcloud builds submit --tag us-central1-docker.pkg.dev/${var.project-id}/${var.prefix}-repo/customwordpress:latest
    #gcloud builds submit --tag gcr.io/${var.project-id}/customwordpress:latest

EOT

    working_dir = "cloudrun"
    interpreter = local.is_windows ? ["PowerShell", "-Command"] : []
  }
}
