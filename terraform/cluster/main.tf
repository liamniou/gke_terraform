resource "google_container_cluster" "primary" {
  name               = var.identifier
  location           = "us-central1-a"
  initial_node_count = 2

  addons_config {
    network_policy_config {
      disabled = true
    }
  }

  master_auth {
    username = var.username
    password = var.password
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
    ]
  }
}

# resource "google_container_node_pool" "primary_preemptible_nodes" {
#   name       = "${var.identifier}-pool"
#   location   = "us-central1-a"
#   cluster    = google_container_cluster.primary.name
#   node_count = 2

#   node_config {
#     preemptible  = true
#     machine_type = "n1-standard-1"

#     metadata = {
#       disable-legacy-endpoints = "true"
#     }

#     oauth_scopes = [
#       "https://www.googleapis.com/auth/devstorage.read_only",
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#       "https://www.googleapis.com/auth/service.management.readonly",
#       "https://www.googleapis.com/auth/servicecontrol",
#       "https://www.googleapis.com/auth/trace.append",
#       "https://www.googleapis.com/auth/compute",
#     ]
#   }
# }