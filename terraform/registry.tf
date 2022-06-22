resource "google_artifact_registry_repository" "demo-repo" {
  project       = module.project-factory.project_id
  depends_on    = [module.enabled_google_apis]
  provider      = google-beta
  location      = var.region
  repository_id = "asm-demo"
  description   = "Demo Registry"
  format        = "DOCKER"
}


resource "google_artifact_registry_repository_iam_member" "registry-access" {
  project       = module.project-factory.project_id
  depends_on    = [google_artifact_registry_repository.demo-repo]
  provider = google-beta
  location = google_artifact_registry_repository.demo-repo.location
  repository = google_artifact_registry_repository.demo-repo.name
  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${module.gke.service_account}"
}