variable "region" {
  description = "AWS region"
  default = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name"
  default = "dev"
}

variable "services" {
  description = "List of Insightric microservices to deploy"
  type = list(string)
  default = [ "insightric-auth-service" ]
}

variable "eks_cluster_name" {
  description = "Name of the EKS Cluster"
  default = "insightric-cluster"
}

variable "vpc_id" {
  description = "VPC ID for EKS Cluster"
  default = null
}

variable "subnet_ids" {
  description = "Subnet IDs for EKS worker nodes"
  type = list(string)
  default = [ ]
}