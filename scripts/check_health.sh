#!/usr/bin/env bash
set -euo pipefail

services=(
  "insightric-auth-service"
#   "insightric-upload-service"
#   "insightric-processing-service"
#   "insightric-ai-service"
#   "insightric-insight-hub"
#   "insightric-notifier-service"
)

NAMESPACE="${NAMESPACE:-default}"
RETRIES=3
SLEEP=5

for svc in "${services[@]}"; do
  echo "Checking health for $svc..."

  # Wait for at least one ready pod with the label
  if ! kubectl wait --for=condition=Ready pod -l app="$svc" -n "$NAMESPACE" --timeout=60s >/dev/null 2>&1; then
    echo "❌ No ready pod found for $svc"
    exit 1
  fi

  POD=$(kubectl get pods -l app="$svc" -n "$NAMESPACE" -o jsonpath='{.items[0].metadata.name}')

  if [ -z "$POD" ]; then
    echo "❌ No pod found for $svc"
    exit 1
  fi

  success=false
  for i in $(seq 1 $RETRIES); do
    echo "Attempt $i for $svc..."
    # Try curling from inside the pod (requires curl in the container)
    if kubectl exec -n "$NAMESPACE" "$POD" -- sh -c 'command -v curl >/dev/null 2>&1 && curl -s --fail http://localhost:8080/api/health' >/dev/null 2>&1; then
      success=true
      break
    fi

    # Fallback: run an ephemeral curl pod to hit the service DNS (requires a Kubernetes Service named as $svc)
    if kubectl run --rm -n "$NAMESPACE" --restart=Never --image=curlimages/curl "curl-test-$svc" -- --max-time 5 -s --fail "http://$svc:8080/api/health" >/dev/null 2>&1; then
      success=true
      break
    fi

    sleep "$SLEEP"
  done

  if [ "$success" = true ]; then
    echo "✅ $svc is healthy"
  else
    echo "❌ $svc failed health check"
    exit 1
  fi
done
