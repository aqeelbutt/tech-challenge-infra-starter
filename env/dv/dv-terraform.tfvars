region          = "us-east-1"
vpc_cidr        = "10.0.0.0/16"
secondary_cidr  = "100.64.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
domain_name     = "rcs-useast1.aoi-tc.com"
cluster_name    = "rcs-tech-challenge"
tags = {
  Project     = "rcs-tech-challenge"
  Owner       = "rcs"
  Environment = "DEV"
}
