#!/bin/bash

set -e

RESOURCE=$1
ACTION=$2
TFVARS_FILE="env/dv/dv-terraform.tfvars"

if [[ -z "$RESOURCE" || -z "$ACTION" ]]; then
  echo "Usage: $0 {vpc|acm|eks|helm|sagemaker|sonarqube|kafka|all} {plan|apply|destroy}"
  exit 1
fi

initialize() {
  echo "Initializing Terraform for $1"
  terraform -chdir=modules/$1 init
}

plan() {
  echo "Planning Terraform changes for $1"
  terraform -chdir=modules/$1 plan -var-file=../../$TFVARS_FILE
}

apply() {
  echo "Applying Terraform changes for $1"
  terraform -chdir=modules/$1 apply -var-file=../../$TFVARS_FILE -auto-approve
}

destroy() {
  echo "Destroying Terraform resources for $1"
  terraform -chdir=modules/$1 destroy -var-file=../../$TFVARS_FILE -auto-approve
}

case $RESOURCE in
  vpc|acm|eks|helm|sagemaker|sonarqube|kafka)
    initialize $RESOURCE
    $ACTION $RESOURCE
    ;;
  all)
    for module in vpc acm eks helm sagemaker sonarqube kafka; do
      initialize $module
      $ACTION $module
    done
    ;;
  *)
    echo "Invalid resource specified. Use {vpc|acm|eks|helm|sagemaker|sonarqube|kafka|all}"
    exit 1
    ;;
esac

### USAGE
# ./provision-script.sh vpc plan
#./provision-script.sh vpc apply
#./provision-script.sh vpc destroy

#./provision-script.sh all plan
#./provision-script.sh all apply
#./provision-script.sh all destroy