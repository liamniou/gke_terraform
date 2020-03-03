provider "google" {
  credentials = file("account.json")
  project     = "fifth-base-269815"
  region      = "us-central1"
  zone        = "us-central1-c"
}

data "google_client_config" "current" {}

data "google_container_cluster" "this" {
  name     = var.identifier
  location = "us-central1-a"
  project  = "fifth-base-269815"
}

provider "kubernetes" {
  version = "1.10"
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.this.master_auth[0].cluster_ca_certificate,
  )
  host             = "https://${data.google_container_cluster.this.endpoint}"
  token            = data.google_client_config.current.access_token
  load_config_file = false
}
