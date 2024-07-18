resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = "default"
  version    = "3.5.2"

  values = [
    templatefile("${path.module}/values-jenkins.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}

resource "kubernetes_ingress" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class"                 = "alb"
      "alb.ingress.kubernetes.io/scheme"            = "internet-facing"
      "alb.ingress.kubernetes.io/listen-ports"      = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/certificate-arn"   = var.certificate_arn
      "alb.ingress.kubernetes.io/healthcheck-path"  = "/login"
      "alb.ingress.kubernetes.io/target-type"       = "ip"
    }
  }

  spec {
    rule {
      host = var.domain_name

      http {
        path {
          path = "/"
          backend {
            service_name = "jenkins"
            service_port = 8080
          }
        }
      }
    }
  }

  depends_on = [helm_release.jenkins]
}