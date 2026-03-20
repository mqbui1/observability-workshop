#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOY_YAML="$SCRIPT_DIR/../deployment.yaml"

echo "==> Applying petclinic deployment..."
kubectl apply -f "$DEPLOY_YAML"

echo "==> Waiting for OTel operator webhook to be ready..."
kubectl rollout status deployment/splunk-otel-collector-operator --timeout=120s

echo "==> Restarting petclinic pods to inject OTel Java agent..."
kubectl rollout restart deployment/api-gateway \
  deployment/customers-service \
  deployment/vets-service \
  deployment/visits-service \
  deployment/admin-server \
  deployment/discovery-server \
  deployment/config-server

echo "==> Waiting for api-gateway to be ready..."
kubectl rollout status deployment/api-gateway --timeout=120s

echo "==> Done. Traces should appear in Splunk within ~60 seconds."
echo "    Environment: $(kubectl get secret workshop-secret -o jsonpath='{.data.env}' | base64 -d 2>/dev/null || echo 'unknown')"
