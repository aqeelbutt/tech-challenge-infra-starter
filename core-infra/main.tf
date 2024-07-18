provider "aws" {
  region = var.region
}

module "vpc" {
  source              = "../modules/vpc"
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
  source          = "../modules/acm"
  domain_name     = var.domain_name
  route53_zone_id = var.route53_zone_id
  tags            = var.tags
  project_name    = var.project_name
  owner           = var.owner

  depends_on = [module.vpc]
}

module "eks" {
  source         = "../modules/eks"
  cluster_name   = var.cluster_name
  vpc_id         = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  secondary_cidr = var.secondary_cidr
  region         = var.region
  tags           = var.tags
  instance_type  = var.instance_type
  key_name       = var.key_name

  depends_on = [module.vpc]
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_ready
}

output "eks_cluster_ca_certificate" {
  value = module.eks.cluster_ca_certificate
}