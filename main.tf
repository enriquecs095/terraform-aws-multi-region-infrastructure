module "master-network-infrastructure" {
  source      = "./modules/network"
  environment = var.environment
  vpcs        = element(var.list_of_vpcs, 0)
  subnets = var.list_of_subnets_master
  name                   = "master"
  cidr_block_route_table = "192.168.1.0/24"
  peering_connection_id  = module.peering-connection-infrastructure.peering_connection_id
  providers = {
    aws.region = aws.region-master
  }
}

module "worker-network-infrastructure" {
  source      = "./modules/network"
  environment = var.environment
  vpcs        = element(var.list_of_vpcs, 1)
  subnets = var.list_of_subnets_worker
  name                   = "worker"
  cidr_block_route_table = "10.0.1.0/24"
  peering_connection_id  = module.peering-connection-infrastructure.peering_connection_id
  providers = {
    aws.region = aws.region-worker
  }
}

module "peering-connection-infrastructure" {
  source        = "./modules/peering_connection"
  environment   = var.environment
  name          = "master_worker"
  vpc_id_master = module.master-network-infrastructure.vpc_id
  vpc_id_worker = module.worker-network-infrastructure.vpc_id
  region_worker = var.region_worker
  providers = {
    aws.region-master = aws.region-master
    aws.region-worker = aws.region-worker
  }
}
################################################################################
module "lb-security-group-infrastructure" {
  source                = "./modules/security_groups"
  environment           = var.environment
  name                  = "lb_sg"
  vpc_id                = module.master-network-infrastructure.vpc_id
  description           = "Allow 443/80 all traffic to Jenkins SG"
  list_of_ingress_rules = var.list_of_ingress_rules_lb
  list_of_egress_rules  = var.list_of_egress_rules_lb
  providers = {
    aws.region = aws.region-master
  }
}

module "master-security-group-infrastructure" {
  source            = "./modules/security_groups_master"
  environment       = var.environment
  name              = "master_sg"
  vpc_id            = module.master-network-infrastructure.vpc_id
  description       = "Allow TCP/8080 & TCP/22"
  security_group_id = module.lb-security-group-infrastructure.sg_id
  providers = {
    aws.region = aws.region-master
  }
}

module "worker-security-group-infrastructure" {
  source                = "./modules/security_groups"
  environment           = var.environment
  name                  = "worker_sg"
  vpc_id                = module.worker-network-infrastructure.vpc_id
  description           = "Allow TCP/22 traffic to us-west-2"
  list_of_ingress_rules = var.list_of_ingress_rules_worker
  list_of_egress_rules  = var.list_of_egress_rules_worker
  providers = {
    aws.region = aws.region-worker
  }
}
################################################################################