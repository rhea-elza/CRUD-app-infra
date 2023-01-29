provider "google" {
  project = var.project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
  credentials = "credentials.json"
}
provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}