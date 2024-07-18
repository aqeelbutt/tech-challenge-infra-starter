output "cluster_name" {
  value = aws_eks_cluster.rcs-tc.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.rcs-tc.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.rcs-tc.certificate_authority[0].data
}

output "eks_cluster_ready" {
  value = aws_eks_cluster.rcs-tc.endpoint
}
