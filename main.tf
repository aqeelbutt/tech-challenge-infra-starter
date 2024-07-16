provider "aws" {
  region = var.region
}

module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  secondary_cidr  = var.secondary_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

module "acm" {
  source       = "./modules/acm"
  domain_name  = var.domain_name
  route53_zone_id = var.route53_zone_id
  tags         = var.tags
}

module "eks" {
  source         = "./modules/eks"
  cluster_name   = var.cluster_name
  vpc_id         = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  secondary_cidr = var.secondary_cidr
  region         = var.region
  tags           = var.tags
}

module "helm" {
  source             = "./modules/helm"
  cluster_name       = module.eks.cluster_name
  cluster_endpoint   = module.eks.cluster_endpoint
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  acm_certificate_arn = module.acm.certificate_arn
  domain_name        = var.domain_name
  tags               = var.tags
}

module "sagemaker" {
  source           = "./modules/sagemaker"
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  tags             = var.tags
}

module "sonarqube" {
  source           = "./modules/sonarqube"
  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  tags             = var.tags
}

module "kafka" {
  source           = "./modules/kafka"
  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  tags             = var.tags
}
