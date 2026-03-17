#!/bin/bash

SERVICE=$1
TENANT=$2

cat <<EOF >> service-registry/services.yaml

  - name: $SERVICE
    tenant: $TENANT
    runtime: python3.11
EOF

echo "Service registered."

cd terraform/environments/dev
terraform apply -auto-approve

#Now a developer runs:
#./create-service.sh payments-api tenantA
# Platform automatically:
# Registers service
# Deploys infrastructure
# Creates API endpoint
