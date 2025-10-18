#!/bin/bash
set -e

echo "Deploying Insightric platform..."

# Deploy infrastructure
echo "Deploying infrastructure with Terraform..."
cd infra/terraform
terraform init
terraform plan
terraform apply -auto-approve
cd ../..

# Deploy to Kubernetes
echo "Deploying services to Kubernetes..."
kubectl apply -f infra/kubernetes/deployments/
kubectl apply -f infra/kubernetes/services/

echo "Deployment complete!"
