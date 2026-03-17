# Automated Tenant Provisioning

# Now implement:

# ./platform-cli create-tenant tenantB


#!/bin/bash

TENANT=$1

mkdir -p terraform/tenants/$TENANT

cat <<EOF > terraform/tenants/$TENANT/services.tf

# Tenant services

EOF

echo "Tenant $TENANT created"

# Later Terraform provisions:

# routing through AWS CloudFront

# identity groups in Amazon Cognito
