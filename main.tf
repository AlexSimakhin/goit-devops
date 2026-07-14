module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = var.state_bucket_name
  table_name  = var.state_table_name
}

module "vpc" {
  source                 = "./modules/vpc"
  vpc_cidr_block         = var.vpc_cidr_block
  public_subnets         = var.public_subnets
  private_subnets        = var.private_subnets
  availability_zones     = var.availability_zones
  vpc_name               = var.vpc_name
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = var.ecr_repository_name
  scan_on_push = var.scan_on_push
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  subnet_ids   = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
}