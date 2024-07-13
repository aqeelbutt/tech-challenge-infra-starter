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

3. **Initialize Terraform:**
    ```sh
    terraform init
    ```

4. **Create a `terraform.tfvars` file:**
    Update the `terraform.tfvars` file with your specific values:
    ```hcl
    region          = "us-east-1"
    vpc_cidr        = "10.0.0.0/16"
    secondary_cidr  = "100.64.0.0/16"
    public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
    domain_name     = "reliablecloudllc.com"
    cluster_name    = "tech-challenge"
    tags = {
      Project = "tech-challenge-a"
      Owner   = "RCS"
    }
    ```

## Deploying Resources

You can deploy individual modules or all resources using the provided `script.sh`. The script supports `plan`, `apply`, and `destroy` actions for the following resources:

- `vpc`
- `acm`
- `eks`
- `helm`
- `sagemaker`
- `sonarqube`
- `kafka`
- `all` (to apply all resources)

### Usage

1. **Plan changes:**
    ```sh
    ./script.sh <RESOURCE> plan
    ```

2. **Apply changes:**
    ```sh
    ./script.sh <RESOURCE> apply
    ```

3. **Destroy resources:**
    ```sh
    ./script.sh <RESOURCE> destroy
    ```

Replace `<RESOURCE>` with the resource you want to manage (e.g., `vpc`, `acm`, `eks`, `all`).

### Example

To deploy all resources:
```sh
./script.sh all apply
```
To destroy all resources:
```sh 
./script.sh all destroy
```
