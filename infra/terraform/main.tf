# ECR Repositories
resource "aws_ecr_repository" "services" {
  for_each = toset(var.services)
  name = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = " Insightric"
    Environment = var.environment
    Service = each.value
  }
}

# IAM Roles
resource "aws_iam_role" "eks_cluster_role" {
  name = "insightric-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow",
            Principal = {Service = "eks.amazonaws.com"}
            Action = "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EKS Cluster
resource "aws_eks_cluster" "insightric_cluster" {
  name = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [ aws_iam_role_policy_attachment.eks_cluster_policy ]
}

# EKS Node Group
resource "aws_eks_node_group" "default" {
  cluster_name = aws_eks_cluster.insightric_cluster.name
  node_group_name = "insightric-nodes"
  node_role_arn = aws_iam_role.eks_cluster_role.arn
  subnet_ids = var.subnet_ids
  scaling_config {
    desired_size = 2
    max_size = 3
    min_size = 1
  }

  instance_types = ["t3.nano"]
  depends_on = [ aws_eks_cluster.insightric_cluster ]
}

