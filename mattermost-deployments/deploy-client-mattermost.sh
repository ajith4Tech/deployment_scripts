#!/usr/bin/env bash
set -e

TEMPLATE_DIR="./templates"
OUTPUT_DIR="./mattermost-yaml"

echo "Mattermost Kubernetes Deployment"

read -p "Enter Ingress Host (e.g. tech4good.mattermost.framewrok.t4gc.in): " INGRESS_HOST
if [[ -z "$INGRESS_HOST" ]]; then
  echo "Ingress Host is required"
  exit 1
fi

read -p "Enter Persistent Volume Storage size (e.g. 10Gi): " STORAGE
STORAGE=${STORAGE:-10Gi}

HOST_PREFIX=$(echo "$INGRESS_HOST" | cut -d. -f1)

export NAMESPACE="$HOST_PREFIX"
export POSTGRES_USER="$HOST_PREFIX"
export POSTGRES_DB="mt-$HOST_PREFIX"
export POSTGRES_PASSWORD="pas-@$HOST_PREFIX"
export STORAGE
export INGRESS_HOST

echo "Derived configuration:"
echo "Namespace: $NAMESPACE"
echo "Postgres User: $POSTGRES_USER"
echo "Postgres DB: $POSTGRES_DB"
echo "Postgres Password: $POSTGRES_PASSWORD"
echo "Ingress Host: $INGRESS_HOST"
echo "Storage Size: $STORAGE"

# Apply files in specified order
declare -a files=(
  "namespace.yaml"
  "mattermost-secret.yaml"
  "configmap.yaml"
  "postgresql-service.yaml"
  "postgresql-statefulset.yaml"
  "mattermost-pvc.yaml"
  "mattermost-deployment.yaml"
  "mattermost-service.yaml"
  "ingress-mattermost.yaml"
)

echo "Applying manifests in strict order..."

for file in "${files[@]}"; do
  echo "Applying $file ..."
  envsubst < "$TEMPLATE_DIR/$file" | kubectl apply -f -
done

echo "All templates applied successfully!"

mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/$HOST_PREFIX.yaml"

echo "Creating consolidated manifest file $OUTPUT_FILE ..."
{
  for file in "${files[@]}"; do
    echo "---"
    envsubst < "$TEMPLATE_DIR/$file"
  done
} > "$OUTPUT_FILE"

echo "Deployment complete and manifest saved to $OUTPUT_FILE"
