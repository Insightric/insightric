#!/bin/bash
set -e

echo "Running tests for Insightric platform..."

# Test Terraform configuration
echo "Validating Terraform configuration..."
cd infra/terraform
terraform init -backend=false
terraform validate
cd ../..

# Test Kubernetes manifests
echo "Validating Kubernetes manifests..."
for file in infra/kubernetes/deployments/*.yaml; do
  kubectl apply --dry-run=client -f "$file"
done

for file in infra/kubernetes/services/*.yaml; do
  kubectl apply --dry-run=client -f "$file"
done

echo "All tests passed!"
