
module "network-infrastructure" {
  source        = "./modules/network"
  region_worker = var.region_worker
  environment   = var.environment
  providers = {
    aws.region-master = aws.region-master
    aws.region-worker = aws.region-worker
  }
}

module "instances-infrastructure" {
  source        = "./modules/instances"
  region_master = var.region_master
  region_worker = var.region_worker
  environment   = var.environment
  providers = {
    aws.region-master = aws.region-master
    aws.region-worker = aws.region-worker
  }
  public_key                  = var.public_key
  subnet_1_id                 = module.network-infrastructure.subnet_1_id
  subnet_1_oregon_id          = module.network-infrastructure.subnet_1_oregon_id
  sg_1_master_id = module.security-group-infrastructure.sg_1_master_id
  sg_1_oregon_id = module.security-group-infrastructure.sg_1_oregon_id
}

module "security-group-infrastructure" {
  source = "./modules/security_groups"
  environment   = var.environment
    providers = {
    aws.region-master = aws.region-master
    aws.region-worker = aws.region-worker
  }
  vpc_1_id = module.network-infrastructure.vpc_1_id
  vpc_1_oregon_id = module.network-infrastructure.vpc_1_oregon_id
}