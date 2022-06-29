module "master-network-infrastructure" {
  source                 = "./modules/network"
  environment            = var.environment
  vpc                    = element(var.list_of_vpcs, 0)
  subnets                = var.list_of_subnets_master
  security_groups        = var.list_of_security_groups_master
  name                   = "master"
  cidr_block_route_table = "192.168.1.0/24"
  peering_connection_id  = module.peering-connection-infrastructure.peering_connection_id
  providers = {
    aws.region = aws.region-master
  }
}

module "worker-network-infrastructure" {
  source                 = "./modules/network"
  environment            = var.environment
  vpc                    = element(var.list_of_vpcs, 1)
  subnets                = var.list_of_subnets_worker
  security_groups        = var.list_of_security_groups_worker
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
