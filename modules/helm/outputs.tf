output "nginx_ingress" {
  value = helm_release.nginx_ingress.name
}

output "jenkins_url" {
  value = kubernetes_service.jenkins.status.load_balancer.ingress[0].hostname
}