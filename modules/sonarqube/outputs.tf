#output "sonarqube_url" {
#  value = join(",", [for lb in kubernetes_service.sonarqube.status[0].load_balancer.ingress : lb.hostname])
#}
