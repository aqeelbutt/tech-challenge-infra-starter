#!/bin/bash

state_bucket_name=$(grep 'state_bucket_name' ../env/dv/dv-terraform.tfvars | awk -F ' *= *' '{print $2}' | tr -d '"')
state_table_name=$(grep 'state_table_name' ../env/dv/dv-terraform.tfvars | awk -F ' *= *' '{print $2}' | tr -d '"')
region=$(grep 'region' ../env/dv/dv-terraform.tfvars | awk -F ' *= *' '{print $2}' | tr -d '"')

# Check if S3 bucket exists, and create if it doesn't
if aws s3 ls "s3://${state_bucket_name}" 2>&1 | grep -q 'NoSuchBucket'; then
  echo "Creating S3 bucket ${state_bucket_name}"
  if [ "${region}" == "us-east-1" ]; then
    aws s3api create-bucket --bucket "${state_bucket_name}" --region "${region}"
  else
    aws s3api create-bucket --bucket "${state_bucket_name}" --region "${region}" --create-bucket-configuration LocationConstraint="${region}"
  fi
  aws s3api put-bucket-versioning --bucket "${state_bucket_name}" --versioning-configuration Status=Enabled
  aws s3api put-bucket-encryption --bucket "${state_bucket_name}" --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

  echo "Waiting for S3 bucket to be fully available..."
  sleep 10

  while ! aws s3 ls "s3://${state_bucket_name}"; do
    echo "S3 bucket ${state_bucket_name} not available yet, waiting..."
    sleep 5
  done
else
  echo "S3 bucket ${state_bucket_name} already exists"
fi

# Check if DynamoDB table exists, and create if it doesn't
if aws dynamodb describe-table --table-name "${state_table_name}" 2>&1 | grep -q 'ResourceNotFoundException'; then
  echo "Creating DynamoDB table ${state_table_name}"
  aws dynamodb create-table \
    --table-name "${state_table_name}" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "${region}"
else
  echo "DynamoDB table ${state_table_name} already exists"
fi

# Initialize Terraform with dynamic backend configuration
terraform init -reconfigure \
  -backend-config="bucket=${state_bucket_name}" \
  -backend-config="key=terraform.tfstate" \
  -backend-config="region=${region}" \
  -backend-config="dynamodb_table=${state_table_name}" \
  -backend-config="encrypt=true"
