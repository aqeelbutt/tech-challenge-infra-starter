# tech-challenge-infra-starter
Infrastructure Starter for Tech Challenges

# AWS Infrastructure Deployment with Terraform and Helm

This repository contains Terraform code to deploy an AWS infrastructure including VPC, ACM, EKS, SageMaker, SonarQube, Strimzi Kafka, and Jenkins. It also includes Helm charts for deploying additional applications.

## Prerequisites

Before you begin, ensure you have the following installed on your local machine:

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://aws.amazon.com/cli/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)
- [jq](https://stedolan.github.io/jq/download/) (for JSON processing in shell scripts)

## Setup

1. **Clone the repository:**
    ```sh
    git clone git@github.com:aqeelbutt/tech-challenge-infra-starter.git
    ```

2. **Configure AWS CLI:**
    ```sh
    aws configure
    ```

3. **Create `terraform.tfvars` file:**
    Create a `terraform.tfvars` file in the root directory with your specific values:
    ```hcl
    state_bucket_name = "rcs-tc-1"
    state_table_name  = "rcs-tc-1"
    region          = "us-east-1"
    vpc_cidr        = "10.0.0.0/16"
    secondary_cidr  = "100.64.0.0/16"
    public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
    domain_name     = "rcs-useast1.aoi-tc.com"
    route53_zone_id = "Z1234567890ABCDEF"
    cluster_name    = "rcs-tech-challenge"
    tags = {
    Project     = "rcs-tech-challenge"
    Owner       = "rcs"
    Environment = "DEV"
    }
    ```

4. **Make scripts executable:**
    ```sh
    chmod +x init_backend.sh
    chmod +x provision.sh
    ```

## Running the Terraform Code

1. **Initialize and apply Terraform configuration:**

    This step will create the S3 bucket and DynamoDB table for state management, initialize the backend, and then apply the Terraform configuration to provision the infrastructure.

    ```sh
    ./init_backend.sh
    ```

### Explanation of the Scripts

#### `init_backend.sh`

This script initializes the Terraform backend using values from `terraform.tfvars` and then calls the `provision.sh` script to apply the Terraform configuration.

```sh
#!/bin/bash

# Load variables from terraform.tfvars
source <(grep = terraform.tfvars | sed 's/ *= */=/g')

# Initialize Terraform with dynamic backend configuration
terraform init -reconfigure \
  -backend-config="bucket=${state_bucket_name}" \
  -backend-config="key=terraform.tfstate" \
  -backend-config="region=${region}" \
  -backend-config="dynamodb_table=${state_table_name}" \
  -backend-config="encrypt=true"

# Run the provision script to apply the infrastructure
./provision.sh
```
#### `provision.sh`
This script applies the Terraform configuration using the values from terraform.tfvars

```sh
#!/bin/bash

# Apply the Terraform configuration
terraform apply -var-file=terraform.tfvars -auto-approve
```

### Accessing Deployed Resources
### Jenkins
Once Jenkins is deployed, you can access it using the LoadBalancer URL. The admin username and password are set to admin/admin.

You can get the Jenkins URL by running:
```sh
terraform output jenkins_url
```

#### SonarQube
SonarQube will be available via a LoadBalancer URL. The admin username and password are set to admin/admin.

You can get the SonarQube URL by running:
```sh
terraform output sonarqube_url
```

### Additional Helm Charts
Additional applications can be deployed using Helm charts located in the helm_charts directory.

### Deploying Sample Application
To deploy the sample application using the provided Helm chart:
```sh 
helm install sample-app ./helm_charts/sample_app
```

#### Customizing Helm Charts
You can customize the Helm charts by modifying the values in the `values.yaml` files located within each chart directory.

### Cleanup
To clean up and destroy all resources created by this Terraform configuration, run:
```sh
terraform destroy -var-file=env/dv/dv-terraform.tfvars -auto-approve
```

### Contributions
Contributions are welcome! Please fork the repository and submit a pull request with your changes.