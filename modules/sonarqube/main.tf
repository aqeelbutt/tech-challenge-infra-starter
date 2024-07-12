resource "helm_release" "sonarqube" {
  name       = "sonarqube"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "sonarqube"
  namespace  = "default"
  values = [
    <<EOF
service:
  type: LoadBalancer

auth:
  adminUser: admin
  adminPassword: admin
EOF
  ]
}

resource "kubernetes_service" "sonarqube" {
  metadata {
    name      = "sonarqube"
    namespace = "default"
  }

  spec {
    type = "LoadBalancer"
    selector = {
      "app.kubernetes.io/name" = "sonarqube"
    }

    port {
      port        = 9000
      target_port = 9000
    }
  }
}