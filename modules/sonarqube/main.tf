resource "helm_release" "sonarqube" {
  name       = "sonarqube"
  repository = "https://charts.sonarqube.org"
  chart      = "sonarqube"
  namespace  = "default"
  version    = "1.0.0"

  values = [
    templatefile("${path.module}/values-sonarqube.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}

resource "kubernetes_service" "sonarqube" {
  metadata {
    name      = "sonarqube"
    namespace = "default"
  }

  spec {
    selector = {
      app = "sonarqube"
    }

    port {
      port        = 80
      target_port = 9000
    }

    type = "LoadBalancer"
  }

  depends_on = [helm_release.sonarqube]
}

resource "kubernetes_ingress" "sonarqube" {
  metadata {
    name      = "sonarqube-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/listen-ports" = jsonencode([{"HTTP": 80}, {"HTTPS": 443}])
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
    }
  }

  spec {
    rule {
      http {
        path {
          path    = "/*"
          backend {
            service_name = "sonarqube"
            service_port = 80
          }
        }
      }
    }
  }

  depends_on = [helm_release.sonarqube]
}