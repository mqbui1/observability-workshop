#!/bin/bash
# Creates the workshop-secret required by the petclinic deployment.
# Run this once before running deploy.sh.
#
# Required values:
#   REALM          - Splunk Observability realm (e.g. us1)
#   ACCESS_TOKEN   - Ingest token (for traces/metrics)
#   API_TOKEN      - API token (for detectors/dashboards)
#   RUM_TOKEN      - RUM ingest token
#   ENV            - deployment.environment tag (e.g. petclinicmbtest)
#   APP            - RUM app name (e.g. petclinic)
#   URL            - Frontend URL for load generator (e.g. http://<loadbalancer-ip>)
#   HEC_TOKEN      - Splunk HEC token (for logs)
#   HEC_URL        - Splunk HEC endpoint
#   DEPLOYMENT     - Deployment name tag

set -e

: "${REALM:?Need to set REALM}"
: "${ACCESS_TOKEN:?Need to set ACCESS_TOKEN}"
: "${API_TOKEN:?Need to set API_TOKEN}"
: "${RUM_TOKEN:?Need to set RUM_TOKEN}"
: "${ENV:?Need to set ENV}"
: "${APP:?Need to set APP}"
: "${URL:?Need to set URL}"
: "${HEC_TOKEN:?Need to set HEC_TOKEN}"
: "${HEC_URL:?Need to set HEC_URL}"
: "${DEPLOYMENT:?Need to set DEPLOYMENT}"

kubectl create secret generic workshop-secret \
  --from-literal=realm="$REALM" \
  --from-literal=access_token="$ACCESS_TOKEN" \
  --from-literal=api_token="$API_TOKEN" \
  --from-literal=rum_token="$RUM_TOKEN" \
  --from-literal=env="$ENV" \
  --from-literal=app="$APP" \
  --from-literal=url="$URL" \
  --from-literal=hec_token="$HEC_TOKEN" \
  --from-literal=hec_url="$HEC_URL" \
  --from-literal=deployment="$DEPLOYMENT" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "==> workshop-secret created/updated."
