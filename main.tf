
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
  public_key    = var.public_key
  providers = {
    aws.region-master = aws.region-master
    aws.region-worker = aws.region-worker
  }
  subnet_1_master_id        = module.network-infrastructure.subnet_1_master_id
  subnet_1_worker_oregon_id = module.network-infrastructure.subnet_1_worker_oregon_id
  sg_1_master_id            = module.security-group-infrastructure.sg_1_master_id
  sg_1_worker_oregon_id     = module.security-group-infrastructure.sg_1_worker_oregon_id
}

module "security-group-infrastructure" {
  source         = "./modules/security_groups"
  environment    = var.environment
  webserver_port = var.webserver_port
  providers = {
    aws.region-master = aws.region-master
    aws.region-worker = aws.region-worker
  }
  vpc_1_master_id        = module.network-infrastructure.vpc_1_master_id
  vpc_1_worker_oregon_id = module.network-infrastructure.vpc_1_worker_oregon_id
}

module "load-balancer-infrastructure" {
  source         = "./modules/alb"
  environment    = var.environment
  webserver_port = var.webserver_port
  providers = {
    aws.region-master = aws.region-master
    aws.region-worker = aws.region-worker
  }
  subnet_1_master_id   = module.network-infrastructure.subnet_1_master_id
  subnet_2_master_id   = module.network-infrastructure.subnet_2_master_id
  vpc_1_master_id      = module.network-infrastructure.vpc_1_master_id
  instance_1_master_id = module.instances-infrastructure.instance_1_master_id
  sg_2_master_id       = module.security-group-infrastructure.sg_2_master_id
  acm_master_arn       = module.acm-infrastructure.acm_master_arn
}

module "acm-infrastructure" {
  source      = "./modules/acm"
  environment = var.environment
  providers = {
    aws.region-master = aws.region-master
    aws.region-worker = aws.region-worker
    
  }
  dns_name     = var.dns_name
  alb_dns_name = module.load-balancer-infrastructure.alb_dns_name
  alb_zone_id  = module.load-balancer-infrastructure.alb_zone_id
}
