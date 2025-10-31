#!/bin/bash

# Prompt for required details
read -p "Enter the client namespace: " CLIENT_NAMESPACE
read -p "Enter the ingress host: " INGRESS_HOST

# Base directory where your deploy script and deployments live
BASE_DIR="listmonk-deployments"
YAML_DIR="${BASE_DIR}/client-listmonk-yaml"
VALUES_FILE="${YAML_DIR}/${CLIENT_NAMESPACE}-listmonk-values.yaml"

mkdir -p "$YAML_DIR"

# Define TLS secret name based on client namespace
TLS_SECRET="${CLIENT_NAMESPACE}-listmonk.tls"

# Generate custom values file with TLS config
cat > "$VALUES_FILE" <<EOF
ingress:
  enabled: true
  className: "traefik"
  host: ${INGRESS_HOST}
  annotations: {}
  tls:
    - hosts:
        - ${INGRESS_HOST}
      secretName: ${TLS_SECRET}

postgres:
  enabled: true
  user: "listmonk"
  password: "@tech4Good"
  ssl_mode: "disable"

listmonk:
  image:
    repository: listmonk/listmonk
    tag: v5.0.3
  replicas: 1
EOF

# Create namespace if not already existing
kubectl create namespace "$CLIENT_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

# NOTE: TLS secret creation should be done manually before deploying, for example:
# kubectl -n "$CLIENT_NAMESPACE" create secret tls "${TLS_SECRET}" --cert=path/to/tls.crt --key=path/to/tls.key

# Deploy using official Helm chart
helm upgrade --install "${CLIENT_NAMESPACE}-listmonk" th0ths-helm-charts/listmonk \
  --version 5.0.3 \
  -f "$VALUES_FILE" \
  --create-namespace \
  -n "$CLIENT_NAMESPACE"

echo "------------------------------------------"
echo "✅ Values file generated at: $VALUES_FILE"
echo "🚀 Helm deployment launched in namespace: $CLIENT_NAMESPACE"
echo "------------------------------------------"
