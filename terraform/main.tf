terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

resource "kubernetes_namespace" "fintech" {
  metadata {
    name = "fintech"
  }
}

resource "kubernetes_deployment" "churn_risk_api" {
  metadata {
    name      = "churn-risk-api"
    namespace = kubernetes_namespace.fintech.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "churn-risk-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "churn-risk-api"
        }
      }

      spec {
        container {
          name              = "churn-risk-api"
          image             = "docker.io/library/churn-risk-api:latest"
          image_pull_policy = "Never"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "churn_risk_api" {
  metadata {
    name      = "churn-risk-api"
    namespace = kubernetes_namespace.fintech.metadata[0].name
  }

  spec {
    selector = {
      app = "churn-risk-api"
    }

    port {
      port        = 5000
      target_port = 5000
    }

    type = "ClusterIP"
  }
}