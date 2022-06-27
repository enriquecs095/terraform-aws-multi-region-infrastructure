module "master-network-infrastructure" {
  source                  = "./modules/network"
  environment             = var.environment
  cidr_block_vpc          = "10.0.0.0/16"
  cidr_block_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  count_subnet            = 2
  dns_support             = true
  dns_hostname            = true
  name                    = "master"
  availability_zone_index = 0
  cidr_block_route_table  = "192.168.1.0/24"
  peering_connection_id   = module.peering-connection-infrastructure.peering_connection_id
  providers = {
    aws.region = aws.region-master
  }
}

module "worker-network-infrastructure" {
  source                  = "./modules/network"
  environment             = var.environment
  cidr_block_vpc          = "192.168.0.0/16"
  cidr_block_subnets      = ["192.168.1.0/24"]
  count_subnet            = 1
  dns_support             = true
  dns_hostname            = true
  name                    = "worker"
  availability_zone_index = 1
  cidr_block_route_table  = "10.0.1.0/24"
  peering_connection_id   = module.peering-connection-infrastructure.peering_connection_id
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

