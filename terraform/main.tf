provider "aws" {
  region = "us-east-1"
}

locals {
  identifier           = "kaniko"
  vpc_cidr             = "10.40.0.0/16"
  public_subnet_cidrs  = ["10.40.0.0/24", "10.40.16.0/24"]
  private_subnet_cidrs = ["10.40.32.0/24", "10.40.48.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

module "networking" {
  source               = "./modules/network"
  identifier           = local.identifier
  vpc_cidr             = local.vpc_cidr
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
  availability_zones   = local.availability_zones
}

