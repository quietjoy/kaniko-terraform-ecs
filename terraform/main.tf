provider "aws" {
  region = "us-east-1"
}

locals {
  identifier             = "kaniko"
  vpc_cidr               = "10.40.0.0/16"
  public_subnet_cidrs    = ["10.40.0.0/24", "10.40.16.0/24"]
  private_subnet_cidrs   = ["10.40.32.0/24", "10.40.48.0/24"]
  availability_zones     = ["us-east-1a", "us-east-1b"]
  inbound_cidr_whitelist = ["69.243.229.207/32"]
  repo_url               = "github.com/quietjoy/kaniko-terraform-ecs"
}

module "networking" {
  source               = "./modules/network"
  identifier           = local.identifier
  vpc_cidr             = local.vpc_cidr
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
  availability_zones   = local.availability_zones
}

module "ecr" {
  source     = "./modules/ecr"
  identifier = local.identifier
}

module "ecs" {
  source                 = "./modules/ecs"
  identifier             = local.identifier
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  private_subnet_ids     = module.networking.private_subnet_ids
  inbound_cidr_whitelist = local.inbound_cidr_whitelist
  kankio_ecr_url         = module.ecr.builder_ecr_repository_url
  app_ecr_url            = module.ecr.app_ecr_repository_url
  repo_url               = local.repo_url
}
