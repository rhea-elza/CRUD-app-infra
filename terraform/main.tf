module "vpc" {
  source = "./modules/vpc"

  vpc_name = "test-net-1"
  project_id=var.project_id

}

module "db" {
     
  source = "./modules/db"
  disk_size     = 10
  instance_type = "db-f1-micro"
  password      = var.db_password
  user          = var.db_username
  vpc_name      = module.vpc.name
  vpc_link      = module.vpc.link
  project_id    = var.project_id
  db_depends_on = [
     module.vpc
   ]
 }



 module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                 = "sadaindia-tvm-poc-de"
  name                       = "uc2-flask-app-cluster-clone-1"
  region                     = var.gke_regions
  zones                      = var.gke_zones
  network                    = "test-net-1"
  subnetwork                 = "test-subnetwork"
  ip_range_pods              = "tf-test-secondary-range-update1"
  ip_range_services          = "tf-test-secondary-range-update2"
  remove_default_node_pool   = true
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  enable_private_endpoint    = false
  enable_private_nodes       = true
  create_service_account     = false
  master_ipv4_cidr_block     = "172.17.0.0/28"
  depends_on = [
    module.vpc
  ]
  node_pools = [
    {
      name                      = "node-pool-1"
      machine_type              = "e2-medium"
      node_locations            = "us-central1-c"
      min_count                 = 1
      max_count                 = 3
      local_ssd_count           = 0
      spot                      = false
      disk_size_gb              = 10
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      enable_gcfs               = false
      enable_gvnic              = false
      auto_repair               = true
      auto_upgrade              = true
      create_service_account    = false
      preemptible               = false
      initial_node_count        = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }


}
data "google_client_config" "default" {}

module "build" {
  source = "./modules/build"
  project_id=var.project_id

}