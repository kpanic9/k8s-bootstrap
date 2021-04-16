resource "kubernetes_cluster_role" "fluentbit" {
  metadata {
    name = "fluent-bit"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_service_account" "fluentbit" {
  metadata {
    name      = "fluent-bit"
    namespace = var.namespace
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "fluentbit" {
  metadata {
    name = "fluent-bit"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.fluentbit.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.fluentbit.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_daemonset" "fluentbit" {
  metadata {
    name      = "fluent-bit-collector"
    namespace = var.namespace
  }

  spec {
    selector {
      match_labels = {
        app = "fluent-bit-collector"
      }
    }

    template {
      metadata {
        labels = {
          app = "fluent-bit-collector"
        }
      }

      spec {
        service_account_name            = kubernetes_service_account.fluentbit.metadata[0].name
        automount_service_account_token = true

        container {
          image   = "fluent/fluent-bit:1.7.0-debug"
          name    = "fluent-bit"
          command = ["/fluent-bit/bin/fluent-bit"]
          args    = ["-c", "/etc/fluent-bit/fluent-bit.conf"]

          resources {
            limits {
              memory = "1Gi"
            }
            requests {
              memory = "256Mi"
            }
          }

          env {
            name  = "NAMESPACE"
            value = var.namespace
          }

          env {
            name  = "MULTILINE_REGEX"
            value = var.fluentbit_multiline_regex
          }

          volume_mount {
            name       = "fluent-bit-config"
            mount_path = "/etc/fluent-bit/"
            read_only  = true
          }

          volume_mount {
            name       = "fluent-bit-storage"
            mount_path = "/fluent-bit-storage/"
          }

          volume_mount {
            name       = "var-log"
            mount_path = "/var/log/"
            read_only  = true
          }

          volume_mount {
            name       = "var-lib-docker-containers"
            mount_path = "/var/lib/docker/containers"
            read_only  = true
          }
        }

        volume {
          name = "fluent-bit-config"
          config_map {
            name = kubernetes_config_map.fluentbit.metadata[0].name
          }
        }

        volume {
          name = "fluent-bit-storage"
          host_path {
            path = "/var/lib/fluent-bit/"
            type = "DirectoryOrCreate"
          }
        }

        volume {
          name = "var-log"
          host_path {
            path = "/var/log"
          }
        }

        volume {
          name = "var-lib-docker-containers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }
      }
    }
  }

  depends_on = [kubernetes_config_map.fluentbit]
}
