resource "helm_release" "strimzi_kafka" {
  name       = "strimzi-kafka"
  repository = "https://strimzi.io/charts/"
  chart      = "strimzi-kafka-operator"
  namespace  = "kafka"
  values = [
    <<EOF
watchNamespaces: "kafka"
EOF
  ]
}

resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }
}