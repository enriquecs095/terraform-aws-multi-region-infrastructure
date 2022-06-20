
module "infrastructure_network" {
  source        = "./modules/network"
  region-master = var.region-master
  region-worker = var.region-worker
  environment   = var.environment
  providers = {
    aws.region-master = aws.region-master
    aws.region-worker = aws.region-worker 
   }
}
