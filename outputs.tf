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
  value = "http://${module.helm.jenkins_url}:8080"
}

output "sonarqube_url" {
  value = module.sonarqube.sonarqube_url
}
