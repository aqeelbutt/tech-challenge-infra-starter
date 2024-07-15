#!/bin/bash

# Load variables from terraform.tfvars
source <(grep = end/dv/dv-terraform.tfvars | sed 's/ *= */=/g')

# Initialize Terraform with dynamic backend configuration
terraform init -reconfigure \
  -backend-config="bucket=${state_bucket_name}" \
  -backend-config="key=terraform.tfstate" \
  -backend-config="region=${region}" \
  -backend-config="dynamodb_table=${state_table_name}" \
  -backend-config="encrypt=true"