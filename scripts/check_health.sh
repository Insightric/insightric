#!/bin/bash
services=(
  "insightric-auth-service"
#   "insightric-upload-service"
#   "insightric-processing-service"
#   "insightric-ai-service"
#   "insightric-insight-hub"
#   "insightric-notifier-service"
)

for svc in "${services[@]}"; do
  echo "Checking health for $svc..."
  url="https://$svc.insightric.dev/api/health"
  if curl -s --fail "$url" > /dev/null; then
    echo "✅ $svc is healthy"
  else
    echo "❌ $svc failed health check"
    exit 1
  fi
done
