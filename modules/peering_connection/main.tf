#Initiate Peering connection request from us-east-1
resource "aws_vpc_peering_connection" "useast1-userst2" {
  provider    = aws.region-master
  peer_vpc_id = var.vpc_id_worker
  vpc_id      = var.vpc_id_master
  peer_region = var.region_worker
  tags = {
    Name = "peering_connection_${var.name}_${var.environment}"
  }
}

#Accept VPC peering request in us-west-2 from us-east-1
resource "aws_vpc_peering_connection_accepter" "accept-peering" {
  provider                  = aws.region-worker
  vpc_peering_connection_id = aws_vpc_peering_connection.useast1-userst2.id
  auto_accept               = true
}
