module "master-network-infrastructure" {
  source                          = "./modules/network"
  environment                     = var.environment
  vpc                             = element(var.list_of_vpcs, 0)
  subnets                         = var.list_of_subnets_master
  security_groups                 = var.list_of_security_groups_master
  name                            = "master"
  cidr_block_route_table          = "192.168.1.0/24"
  peering_connection_id           = module.peering-connection-infrastructure.peering_connection_id
  providers = {
    aws = aws.region-master
  }
}

module "worker-network-infrastructure" {
  source                          = "./modules/network"
  environment                     = var.environment
  vpc                             = element(var.list_of_vpcs, 1)
  subnets                         = var.list_of_subnets_worker
  security_groups                 = var.list_of_security_groups_worker
  name                            = "worker"
  cidr_block_route_table          = "10.0.1.0/24"
  peering_connection_id           = module.peering-connection-infrastructure.peering_connection_id
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

/*
module "ec2-master-infrastructure" {
  source                = "./modules/ec2"
  environment           = var.environment
  name                  = "master"
  instances_count       = 1
  public_key            = var.public_key
  subnet_id             = module.master-network-infrastructure.subnets_id
  security_groups_id    = element(module.master-network-infrastructure.security_groups_id, 1)
  region                = var.region_master
  ansible_playbook_file = "jenkins-master-sample.yml"
  master_private_ip     = element(["null"],0)
  providers = {
    aws.region = aws.region-master
  }
}

module "ec2-worker-infrastructure" {
  source                = "./modules/ec2"
  environment           = var.environment
  name                  = "worker"
  instances_count       = 1
  public_key            = var.public_key
  subnet_id             = element(module.worker-network-infrastructure.subnets_id, 0)
  security_groups_id    = module.worker-network-infrastructure.security_groups_id
  region                = var.region_worker
  ansible_playbook_file = "jenkins-worker-sample.yml"
  master_private_ip     = element(module.ec2-master-infrastructure.master_private_ip,0)
  providers = {
    aws.region = aws.region-worker
  }
}*/
