variable "gcp_project_name" {
  description = "The name of the GCP project where the db and Cloud SQL Proxy will be created"
  type = string
}

variable "gcp_region" {
  description = "The GCP region where the db and Cloud SQL Proxy will be created"
  type = string
}

variable "gcp_zone" {
  description = "The GCP availability zone where the db and Cloud SQL Proxy will be created"
  type = string
}
variable "gke_regions" {
  description = "The GCP region where the db and Cloud SQL Proxy will be created"
  type = string
}

variable "gke_zones" {
  description = "The GCP availability zone where the db and Cloud SQL Proxy will be created"
  type = list(string)
}
variable "project_id" {

}

variable "gke_cluster_name" {
    type = string
    description = "GKE Cluster name"

}

variable "gke_default_nodepool_name" {
    type = string
    description = "GKE default Node pool name"

}


#db

variable "db_depends_on" {
  description = "A single resource that the database instance depends on"
  type        = any
}

variable "disk_size" {
  description = "The size in GB of the disk used by the db"
  type        = number
}

variable "instance_type" {
  description = "The instance type of the VM that will run the db (e.g. db-f1-micro, db-custom-8-32768)"
  type        = string
}

variable "db_password" {
  description = "The db password used to connect to the Postgers db"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "The username of the db user"
  type        = string
  sensitive = true
}

variable "vpc_link" {
  description = "A link to the VPC where the db will live (i.e. google_compute_network.some_vpc.self_link)"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC where the db will live"
  type        = string
}



variable "db_instance_name" {
  description = "The name of the Cloud SQL db, e.g. my-project:us-centra1:my-sql-db"
  type        = string
}

