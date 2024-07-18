provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.authenticator.token
}

data "aws_eks_cluster_auth" "authenticator" {
  name = var.cluster_name
}

module "k8s" {
  source                  = "../modules/k8s"
  cluster_name            = var.cluster_name
  cluster_endpoint        = var.cluster_endpoint
  cluster_ca_certificate  = var.cluster_ca_certificate
  secondary_cidr          = var.secondary_cidr
  tags                    = var.tags
  certificate_arn         = var.certificate_arn
  domain_name             = var.domain_name

  providers = {
    kubernetes = kubernetes
  }
}

module "sonarqube" {
  source           = "../modules/sonarqube"
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  cluster_ca_certificate = var.cluster_ca_certificate
  tags             = var.tags
  domain_name      = var.domain_name
  certificate_arn  = var.certificate_arn

  depends_on = [module.k8s]
}

module "kafka" {
  source           = "../modules/kafka"
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  cluster_ca_certificate = var.cluster_ca_certificate
  tags             = var.tags
  domain_name      = var.domain_name
  certificate_arn  = var.certificate_arn

  depends_on = [module.k8s]
}

module "jenkins" {
  source           = "../modules/jenkins"
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  cluster_ca_certificate = var.cluster_ca_certificate
  tags             = var.tags
  domain_name      = var.domain_name
  certificate_arn  = var.certificate_arn

  depends_on = [module.k8s]
}

variable "cluster_endpoint" {}
variable "cluster_ca_certificate" {}
variable "tags" {}
variable "certificate_arn" {}