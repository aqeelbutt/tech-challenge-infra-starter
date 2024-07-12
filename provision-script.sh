#!/bin/bash

set -e

RESOURCE=$1
ACTION=$2

if [[ -z "$RESOURCE" || -z "$ACTION" ]]; then
  echo "Usage: $0 {vpc|acm|eks|helm|sagemaker|sonarqube|all} {plan|apply|destroy}"
  exit 1
fi

initialize() {
  echo "Initializing Terraform for $1"
  terraform -chdir=modules/$1 init
}

plan() {
  echo "Planning Terraform changes for $1"
  terraform -chdir=modules/$1 plan
}

apply() {
  echo "Applying Terraform changes for $1"
  terraform -chdir=modules/$1 apply -auto-approve
}

destroy() {
  echo "Destroying Terraform resources for $1"
  terraform -chdir=modules/$1 destroy -auto-approve
}

case $RESOURCE in
  vpc|acm|eks|helm|sagemaker|sonarqube)
    initialize $RESOURCE
    $ACTION $RESOURCE
    ;;
  all)
    for module in vpc acm eks helm sagemaker sonarqube; do
      initialize $module
      $ACTION $module
    done
    ;;
  *)
    echo "Invalid resource specified. Use {vpc|acm|eks|helm|sagemaker|sonarqube|all}"
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