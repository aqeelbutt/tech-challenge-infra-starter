resource "helm_release" "strimzi_kafka" {
  name       = "strimzi-kafka"
  repository = "https://strimzi.io/charts/"
  chart      = "strimzi-kafka-operator"
  namespace  = "kafka"
  version    = "0.20.1"

  values = [
    templatefile("${path.module}/values-strimzi-kafka.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}

resource "kubernetes_ingress" "kafka" {
  metadata {
    name      = "kafka"
    namespace = "kafka"
    annotations = {
      "kubernetes.io/ingress.class"                 = "alb"
      "alb.ingress.kubernetes.io/scheme"            = "internet-facing"
      "alb.ingress.kubernetes.io/listen-ports"      = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/certificate-arn"   = var.certificate_arn
    }
  }

  spec {
    rule {
      host = var.domain_name

      http {
        path {
          path = "/"
          backend {
            service_name = "kafka"
            service_port = 9092
          }
        }
      }
    }
  }

  depends_on = [helm_release.strimzi_kafka]
}