# ECR Repositories
resource "aws_ecr_repository" "services" {
  for_each = toset(var.services)
  name     = lower(replace(each.value, "_", "-"))

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true

  tags = {
    Project     = "Insightric"
    Environment = var.environment
    Service     = each.value
  }
}

# IAM Role for EKS Control Plane (Cluster)
resource "aws_iam_role" "eks_cluster_role" {
  name = "insightric-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}


# IAM Role for EKS Node Group (Worker Nodes)
resource "aws_iam_role" "eks_node_role" {
  name = "insightric-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach required managed policies
resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
# resource "kubernetes_config_map" "aws_auth" {
#   depends_on = [
#     aws_eks_cluster.insightric_cluster,
#     aws_eks_node_group.default
#   ]

#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = yamlencode([
#       {
#         rolearn  = aws_iam_role.eks_node_role.arn
#         username = "system:node:{{EC2PrivateDNSName}}"
#         groups = [
#           "system:bootstrappers",
#           "system:nodes"
#         ]
#       },
#       {
#         rolearn  = "arn:aws:iam::136086620476:role/insightric-gha-deployer"
#         username = "github-actions"
#         groups   = ["system:masters"]
#       }
#     ])
#   }

#   lifecycle {
#     prevent_destroy = false
#     ignore_changes  = [data]
#   }
# }

# EKS Cluster
resource "aws_eks_cluster" "insightric_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy
  ]
}

# EKS Node Group
resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.insightric_cluster.name
  node_group_name = "insightric-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.micro"]

  depends_on = [
    aws_eks_cluster.insightric_cluster,
    aws_iam_role_policy_attachment.eks_worker_node,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_readonly
  ]
}

resource "aws_ecr_lifecycle_policy" "cleanup" {
  for_each = aws_ecr_repository.services

  repository = each.value.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 1 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 1
      }
      action = {
        type = "expire"
      }
    }]
  })
}
