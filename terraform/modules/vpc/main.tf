

resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  #routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
  project = var.project_id

}

resource "google_compute_subnetwork" "test-subnetwork" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.230.18.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc.name
  project       = var.project_id
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "10.48.0.0/14"
  }
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update2"
    ip_cidr_range = "10.52.0.0/20"
  }
  depends_on = [
    google_compute_network.vpc
  ]
}
resource "google_compute_subnetwork" "test-subnetwork-2" {
  name          = "test-subnetwork-2"
  ip_cidr_range = "10.220.18.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc.name
  project       = var.project_id
  

  depends_on = [
    google_compute_network.vpc
  ]
}




resource "google_compute_firewall" "allow_ssh" {
  name        = "allow-ssh"
  description = "Allow SSH traffic to any instance tagged with 'ssh-enabled'"
  network     = google_compute_network.vpc.name
  direction   = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-enabled"]
  project = var.project_id
}
