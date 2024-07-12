output "sonarqube_url" {
  value = kubernetes_service.sonarqube.status.load_balancer.ingress[0].hostname
}