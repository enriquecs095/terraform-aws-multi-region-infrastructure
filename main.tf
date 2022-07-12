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
    aws = aws.region-master
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
    aws = aws.region-worker
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


module "ec2-master-infrastructure" {
  source               = "./modules/ec2"
  environment          = var.environment
  name                 = "master"
  public_key           = var.public_key
  instance_data        = element(var.list_of_instances, 0)
  security_groups_list = module.master-network-infrastructure.security_groups_id
  subnets_id           = module.master-network-infrastructure.subnets_id
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
  instance_data        = element(var.list_of_instances, 1)
  security_groups_list = module.worker-network-infrastructure.security_groups_id
  subnets_id           = module.worker-network-infrastructure.subnets_id
  region               = var.region_worker
  providers = {
    aws = aws.region-worker
  }
}
