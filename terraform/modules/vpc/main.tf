

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


resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
}

resource "google_compute_global_address" "private_ip_block" {
  name         = "private-ip-block"
  description  = "A block of private IP addresses that are accessible only from within the VPC."
  purpose      = "VPC_PEERING"
  address_type = "INTERNAL"
  ip_version   = "IPV4"
  # We don't specify a address range because Google will automatically assign one for us.
  prefix_length = 20 # ~4k IPs
  network       = var.vpc_name
  project = var.project_id
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
