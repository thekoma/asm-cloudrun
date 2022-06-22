module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 13.0.0"

  project_id                  = module.project-factory.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "gkehub.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "anthos.googleapis.com",
    "meshconfig.googleapis.com",
    "servicemanagement.googleapis.com",
    "meshca.googleapis.com",
    "stackdriver.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "meshtelemetry.googleapis.com",
    "cloudtrace.googleapis.com",
    "logging.googleapis.com",
    "containerregistry.googleapis.com",
    "cloudbuild.googleapis.com"
  ]
}

module "gke" {
  version               = "~> 21.0"
  depends_on            = [module.enabled_google_apis]
  source                = "terraform-google-modules/kubernetes-engine/google"
  project_id            = module.project-factory.project_id
  name                  = "${var.gke_cluster_name}-${local.name_suffix}"
  region                = var.region
  release_channel       = "STABLE"
  enable_shielded_nodes = true
  remove_default_node_pool          = true
  node_pools            = [
    {
      name                      = "default-node-pool"
      machine_type              = "e2-standard-8"
      local_ssd_count           = 0
      disk_size_gb              = 100
      min_count                 = 1
      max_count                 = 3
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      enable_gcfs               = false
      enable_secure_boot        = true
      auto_repair               = true
      auto_upgrade              = true
      preemptible               = true

    }
  ]
  network               = var.network_name
  subnetwork            = var.subnetwork
  ip_range_pods         = var.ip_range_pods_name
  ip_range_services     = var.ip_range_services_name
  identity_namespace    = "enabled"
}


# resource "google_gke_hub_membership" "membership" {
#   provider      = google-beta
#   depends_on    = [module.gke, module.enabled_google_apis]
#   project       = module.project-factory.project_id
#   membership_id = "membership-hub-${module.gke.name}"
#   endpoint {
#     gke_cluster {
#       resource_link = "//container.googleapis.com/${module.gke.cluster_id}"
#     }
#   }
# }

# resource "google_gke_hub_feature" "mesh" {
#   depends_on  = [ module.enabled_google_apis ]
#   name        = "servicemesh"
#   project     = module.project-factory.project_id
#   location    = "global"
#   provider    = google-beta
# }


# resource "google_gke_hub_feature" "configmanagement_acm_feature" {
#   name     = "configmanagement"
#   location = "global"
#   provider = google-beta
# }