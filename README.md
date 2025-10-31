# Deplyment scripts

This repository contains helper scripts and Kubernetes YAML templates to deploy open‑source applications and softwares in a Kubernetes (k8s) environment.

## Contents — deployments

The repo currently provides automated deployments for three applications:

1. Mattermost
   - Description: Self‑hosted team chat service (web + backend + Postgres).
   - Directory structure:
     - mattermost-deployments/
       - deploy-client-mattermost.sh
       - templates/
         - ingress-mattermost.yaml
         - mattermost-deployment.yaml
         - configmap.yaml
         - mattermost-secret.yaml
         - postgresql-statefulset.yaml

2. WordPress
   - Description: Popular CMS (PHP + MySQL).
   - Directory structure:
     - wordpress_deployments/
       - wordpress-deployclient.sh
       - templates/
         - wordpress-deployment.yaml
         - wp-configmap.yaml
         - wp-secret.yaml
         - mysql-statefulset.yaml
         - wp-ingress.yaml
         - wp-service.yaml

3. Listmonk
   - Description: Self‑hosted email/newsletter manager (Go + Postgres).
   - Directory structure:
     - listmonk-deployments/
       - deploy-listmonk.sh
       - client-listmonk-yaml (Auto generated)

## Quick prerequisites

- kubectl configured for target cluster
- helm (required by Listmonk deployment)
- envsubst (for template variable substitution) or sed
- Optional: cert-manager / TLS secrets for ingress TLS

## Usage
````
./<script-name>.sh
````
