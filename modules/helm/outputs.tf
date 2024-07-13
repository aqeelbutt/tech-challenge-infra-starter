output "nginx_ingress" {
  value = helm_release.nginx_ingress.name
}

output "jenkins_url" {
  value = kubernetes_service.jenkins.status[0].load_balancer[0].ingress[0].hostname
}
