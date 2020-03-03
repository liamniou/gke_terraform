resource "kubernetes_deployment" "producer" {
  metadata {
    name = "${var.identifier}-producer"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = var.identifier
      }
    }

    template {
      metadata {
        labels = {
          name = var.identifier
        }
      }

      spec {
        container {
          image = "liamnou/frontend:1.0.0"
          name  = "${var.identifier}-producer"
          env {
            name  = "RABBIT_HOST"
            value = "my-release-rabbitmq"
          }

          env {
            name  = "RABBIT_PASSWORD"
            value = "secretpassword"
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "producer" {
  metadata {
    name = "${var.identifier}-producer-service"
  }
  spec {
    selector = {
      name = var.identifier
    }
    session_affinity = "ClientIP"
    port {
      port        = 5000
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}







# resource "kubernetes_persistent_volume" "consumer" {
#   metadata {
#     name = "consumer"
#   }
#   spec {
#     capacity = {
#       storage = "5Gi"
#     }
#     access_modes = ["ReadWriteMany"]
#     persistent_volume_source {
#       gce_persistent_disk {
#         fs_type = "ext4"
#         pd_name = "consumer-pvc"
#       }
#     }
#   }
# }

# resource "kubernetes_persistent_volume_claim" "consumer" {
#   metadata {
#     name = "consumer"
#   }
#   spec {
#     access_modes = ["ReadWriteMany"]
#     resources {
#       requests = {
#         storage = "1Gi"
#       }
#     }
#     volume_name = "${kubernetes_persistent_volume.consumer.metadata.0.name}"
#   }
# }

# resource "kubernetes_deployment" "consumer" {
#   metadata {
#     name = "${var.identifier}-consumer"
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         name = var.identifier
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           name = var.identifier
#         }
#       }

#       spec {
#         container {
#           image = "liamnou/consumer:1.0.0"
#           name  = "${var.identifier}-consumer"
#           env {
#             name  = "RABBIT_HOST"
#             value = "my-release-rabbitmq"
#           }

#           env {
#             name  = "RABBIT_PASSWORD"
#             value = "secretpassword"
#           }

#           env {
#             name  = "PVC_MOUNT_POINT"
#             value = "/pvc_mount"
#           }

#           resources {
#             limits {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#             requests {
#               cpu    = "250m"
#               memory = "50Mi"
#             }
#           }
#           volume_mount {
#             name       = "${var.identifier}-volume"
#             mount_path = "/pvc_mount"
#           }
#         }

#         volume {
#           persistent_volume_claim {
#             claim_name = kubernetes_persistent_volume_claim.consumer.metadata.0.name
#           }

#           name = "${var.identifier}-volume"
#         }
#       }
#     }
#   }
# }

resource "kubernetes_persistent_volume_claim" "example" {
  metadata {
    name = "exampleclaimname"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.example.metadata.0.name}"
    storage_class_name = "standard"
  }
}

resource "kubernetes_persistent_volume" "example" {
  metadata {
    name = "examplevolumename"
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      gce_persistent_disk {
        pd_name = "test-disk123"
      }
    }
    storage_class_name = "standard"
  }
}

resource "kubernetes_deployment" "consumer" {
  metadata {
    name = "${var.identifier}-consumer"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = var.identifier
      }
    }

    template {
      metadata {
        labels = {
          name = var.identifier
        }
      }

      spec {
        container {
          image = "liamnou/consumer:1.0.0"
          name  = "${var.identifier}-consumer"
          env {
            name  = "RABBIT_HOST"
            value = "my-release-rabbitmq"
          }

          env {
            name  = "RABBIT_PASSWORD"
            value = "secretpassword"
          }

          env {
            name  = "PVC_MOUNT_POINT"
            value = "/pvc_mount"
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          volume_mount {
            name       = "${var.identifier}-volume"
            mount_path = "/pvc_mount"
          }
        }

        volume {
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.example.metadata.0.name
          }

          name = "${var.identifier}-volume"
        }
      }
    }
  }
}