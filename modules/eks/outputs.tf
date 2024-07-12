output "cluster_name" {
  value = aws_eks_cluster.example.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.example.certificate_authority[0].data
}