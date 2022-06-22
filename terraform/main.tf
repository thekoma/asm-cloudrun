provider "google" {
  credentials = "./credentials.json"
  region      = var.region
}

provider "google-beta" {
  credentials = "./credentials.json"
  region      = var.region
}

module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 13.0.0"
  name                 = var.project_name
  folder_id            = var.folder_id
  random_project_id    = true
  org_id               = var.org_id
  billing_account      = var.billing_account
  activate_apis        = [
    "compute.googleapis.com"
  ]
  auto_create_network = true
}


resource "google_compute_firewall" "monitoring" {
  name    = "monitoring"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}