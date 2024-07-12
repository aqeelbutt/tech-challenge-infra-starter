output "strimzi_kafka_release" {
  value = helm_release.strimzi_kafka.name
}