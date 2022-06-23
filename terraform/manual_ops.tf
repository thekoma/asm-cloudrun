provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

data "google_client_config" "default" {}



module "cpr" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 3.1"

  project_id       = module.project-factory.project_id
  cluster_name     = module.gke.name
  cluster_location = module.gke.location
  internal_ip      = false

  kubectl_create_command  = "${path.module}/scripts/create_cpr.sh ${local.cloudrun_revision_name}"
  kubectl_destroy_command = "${path.module}/scripts/destroy_cpr.sh ${local.cloudrun_revision_name}"

  module_depends_on = [module.asm]
}