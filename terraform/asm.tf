
# resource "google_gke_hub_membership" "membership" {
#   provider      = google-beta
#   project       = module.project-factory.project_id
#   membership_id = "membership-hub-${module.gke.name}"
#   endpoint {
#     gke_cluster {
#       resource_link = "//container.googleapis.com/${module.gke.cluster_id}"
#     }
#   }
# }

module "asm" {
  source                    = "terraform-google-modules/kubernetes-engine/google//modules/asm"
  project_id                = module.project-factory.project_id
  cluster_name              = module.gke.name
  cluster_location          = module.gke.location
  enable_fleet_registration = true
  enable_mesh_feature       = true
  enable_cni        = true
}

resource "google_gke_hub_feature" "cloudrun" {
  depends_on  = [ module.asm ]
  location    = "global"
  name        = "appdevexperience"
  project     = module.project-factory.project_id
  provider    = google-beta
}



# resource "google_gke_hub_feature" "configmanagement_acm_feature" {
#   name     = "configmanagement"
#   location = "global"
#   provider = google-beta
# }

# resource "google_gke_hub_feature_membership" "feature_member" {
#   provider   = google-beta
#   location   = "global"
#   feature    = "configmanagement"
#   membership = google_gke_hub_membership.membership.membership_id
#   configmanagement {
#     version = "1.8.0"
#     config_sync {
#       source_format = "unstructured"
#       git {
#         sync_repo   = var.sync_repo
#         sync_branch = var.sync_branch
#         policy_dir  = var.policy_dir
#         secret_type = "none"
#       }
#     }
#   }
#   depends_on = [
#     google_gke_hub_feature.configmanagement_acm_feature
#   ]
# }