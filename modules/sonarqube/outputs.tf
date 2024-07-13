output "sonarqube_url" {
  value = kubernetes_service.sonarqube.status[0].load_balancer[0].ingress[0].hostname
}