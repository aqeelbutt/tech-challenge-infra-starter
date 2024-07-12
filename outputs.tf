output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "acm_certificate_arn" {
  value = module.acm.certificate_arn
}

output "jenkins_admin_username" {
  value = "admin"
}

output "jenkins_admin_password" {
  value = "adminPassword"
}

output "jenkins_url" {
  value = "http://${kubernetes_service.jenkins.status.load_balancer.ingress[0].hostname}:8080"
}