provider "aws" {
  region = var.region
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  secondary_cidr      = var.secondary_cidr
  availability_zones  = var.availability_zones
  tags                = var.tags
  project_name        = var.project_name
  jumpbox_ami         = var.jumpbox_ami
  jumpbox_instance_type = var.jumpbox_instance_type
  key_name            = var.key_name
}

module "acm" {
  source          = "./modules/acm"
  domain_name     = var.domain_name
  route53_zone_id = var.route53_zone_id
  tags            = var.tags
  project_name    = var.project_name
  owner           = var.owner

  depends_on = [module.vpc]
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
  instance_type  = var.instance_type
  key_name       = var.key_name
  domain_name    = var.domain_name
  certificate_arn = module.acm.acm_certificate_arn

  depends_on = [module.vpc]
}

data "aws_eks_cluster_auth" "authenticator" {
  name = module.eks.cluster_name
}

locals {
  eks_ready              = module.eks.eks_cluster_ready
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  cluster_auth_token     = data.aws_eks_cluster_auth.authenticator.token
}

provider "kubernetes" {
  host                   = try(local.eks_ready, null)
  cluster_ca_certificate = try(local.cluster_ca_certificate, null)
  token                  = try(local.cluster_auth_token, null)
}

module "sagemaker" {
  source           = "./modules/sagemaker"
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  private_subnet_cidrs = var.private_subnet_cidrs
  tags             = var.tags
  cluster_name     = var.cluster_name

  depends_on = [module.vpc]
}

module "sonarqube" {
  source           = "./modules/sonarqube"
  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.eks_cluster_ready
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  tags             = var.tags
  domain_name      = var.domain_name
  certificate_arn  = module.acm.acm_certificate_arn

  depends_on = [module.eks]
}

module "kafka" {
  source           = "./modules/kafka"
  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.eks_cluster_ready
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  tags             = var.tags
  domain_name      = var.domain_name
  certificate_arn  = module.acm.acm_certificate_arn

  depends_on = [module.eks]
}

module "jenkins" {
  source           = "./modules/jenkins"
  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.eks_cluster_ready
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  tags             = var.tags
  domain_name      = var.domain_name
  certificate_arn  = module.acm.acm_certificate_arn

  depends_on = [module.eks]
}