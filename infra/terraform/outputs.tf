output "ecr_repositories" {
  value = { for k, v in aws_ecr_repository.services : k => v.repository_url }
}

output "eks_cluster_name" {
  value = aws_eks_cluster.insightric_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.insightric_cluster.endpoint
}

output "eks_cluster_certificate" {
  value = aws_eks_cluster.insightric_cluster.certificate_authority[0].data
}
