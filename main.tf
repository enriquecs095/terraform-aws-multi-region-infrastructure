module "master-network-infrastructure" {
  source                 = "./modules/network"
  environment            = var.environment
  vpc                    = var.vpcs["vpc_1"]
  subnets                = var.subnets["subnets_master_region_1"]
  security_groups        = var.security_groups["sg_master_region_1"]
  name                   = "master"
  cidr_block_route_table = "192.168.1.0/24"
  peering_connection_id  = module.peering-connection-infrastructure.peering_connection_id
  providers = {
    aws = aws.region-master
  }
}

module "worker-network-infrastructure" {
  source                 = "./modules/network"
  environment            = var.environment
  vpc                    = var.vpcs["vpc_2"]
  subnets                = var.subnets["subnets_worker_region_1"]
  security_groups        = var.security_groups["sg_worker_region_1"]
  name                   = "worker"
  cidr_block_route_table = "10.0.1.0/24"
  peering_connection_id  = module.peering-connection-infrastructure.peering_connection_id
  providers = {
    aws = aws.region-worker
  }
}

module "peering-connection-infrastructure" {
  source        = "./modules/peering_connection"
  environment   = var.environment
  name          = "master_worker_1"
  vpc_id_master = module.master-network-infrastructure.vpc_id
  vpc_id_worker = module.worker-network-infrastructure.vpc_id
  region_worker = var.region_worker
  providers = {
    aws.region-master = aws.region-master
    aws.region-worker = aws.region-worker
  }
}

module "ec2-master-infrastructure" {
  source               = "./modules/ec2"
  environment          = var.environment
  name                 = "master"
  public_key           = var.public_key
  instance_data        = var.instances["instance_master_1"]
  security_groups_list = module.master-network-infrastructure.security_groups_id
  subnets_id           = module.master-network-infrastructure.subnets_id
  vpc_id               = module.master-network-infrastructure.vpc_id
  region               = var.region_master
  providers = {
    aws = aws.region-master
  }
}

module "ec2-worker-infrastructure" {
  source               = "./modules/ec2"
  environment          = var.environment
  name                 = "worker"
  public_key           = var.public_key
  instance_data        = var.instances["instance_worker_1"]
  security_groups_list = module.worker-network-infrastructure.security_groups_id
  subnets_id           = module.worker-network-infrastructure.subnets_id
  vpc_id               = module.worker-network-infrastructure.vpc_id
  region               = var.region_worker
  providers = {
    aws = aws.region-worker
  }
}

module "load-balancer-infrastructure" {
  source               = "./modules/alb"
  environment          = var.environment
  load_balancer        = var.load_balancers["lb-master-1"]
  acm_certificate_arn  = module.acm-infrastructure.acm_certificate_arn
  vpc_id               = module.master-network-infrastructure.vpc_id
  security_groups_list = module.master-network-infrastructure.security_groups_id
  subnets_list         = module.master-network-infrastructure.subnets_id
  instances_list       = module.ec2-master-infrastructure.instances_id
  providers = {
    aws = aws.region-master
  }
}

module "acm-infrastructure" {
  source          = "./modules/acm"
  environment     = var.environment
  acm_certificate = var.acm_certificates["acm_certificate_1"]
  alb_dns_name    = module.load-balancer-infrastructure.alb_dns_name
  alb_zone_id     = module.load-balancer-infrastructure.alb_zone_id
  providers = {
    aws = aws.region-master
  }
}
