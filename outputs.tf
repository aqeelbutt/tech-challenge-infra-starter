output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "acm_certificate_arn" {
  value = module.acm.acm_certificate_arn
}

output "jenkins_admin_username" {
  value = "admin"
}

output "jenkins_admin_password" {
  value = "adminPassword"
}

output "eks_cluster_ready" {
  value = module.eks.eks_cluster_ready
}

output "cluster_ca_certificate" {
  value = module.eks.cluster_ca_certificate
}

output "cluster_name" {
  value = module.eks.cluster_name
}
