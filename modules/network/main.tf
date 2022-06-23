
#Create VPC in us-east-1
resource "aws_vpc" "vpc-master" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = join("_", ["master-vpc-jenkins", var.environment])
  }
}

#Create VPC in us-west-2
resource "aws_vpc" "vpc-worker-oregon" {
  provider             = aws.region-worker
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = join("_", ["worker-vpc-jenkins", var.environment])
  }
}

#Create IGW in us-east-1
resource "aws_internet_gateway" "igw" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc-master.id
  tags = {
    Name = join("_", ["gateway-master", var.environment])
  }
}

#Create IGW in us-west-2
resource "aws_internet_gateway" "igw-oregon" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.vpc-worker-oregon.id
  tags = {
    Name = join("_", ["gateway-worker", var.environment])
  }
}

#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}

#Create subnet #1 in us-east-1
resource "aws_subnet" "subnet-1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc-master.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = join("_", ["subnet-1-master", var.environment])
  }
}

#Create subnet #2 in us-east-1
resource "aws_subnet" "subnet-2" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc-master.id
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = join("_", ["subnet-2-master", var.environment])
  }
}

#Create subnet #1 in us-west-2
resource "aws_subnet" "subnet-1-oregon" {
  provider   = aws.region-worker
  vpc_id     = aws_vpc.vpc-worker-oregon.id
  cidr_block = "192.168.1.0/24"
  tags = {
    Name = join("_", ["subnet-worker", var.environment])
  }
}

#Initiate Peering connection request from us-east-1
resource "aws_vpc_peering_connection" "useast1-userst2" {
  provider    = aws.region-master
  peer_vpc_id = aws_vpc.vpc-worker-oregon.id
  vpc_id      = aws_vpc.vpc-master.id
  peer_region = var.region_worker
  tags = {
    Name = join("_", ["peering-connection", var.environment])
  }
}

#Accept VPC peering request in us-west-2 from us-east-1
resource "aws_vpc_peering_connection_accepter" "accept-peering" {
  provider                  = aws.region-worker
  vpc_peering_connection_id = aws_vpc_peering_connection.useast1-userst2.id
  auto_accept               = true
}


#Create route table in us-east-1
resource "aws_route_table" "internet-route" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc-master.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    cidr_block                = "192.168.1.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.useast1-userst2.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = join("_", ["Master-Region-RT", var.environment])
  }

}

#Overwrite default route table of VPC(Master) with our route table entries 
resource "aws_main_route_table_association" "set-master-default-rt-assoc" {
  provider       = aws.region-master
  vpc_id         = aws_vpc.vpc-master.id
  route_table_id = aws_route_table.internet-route.id

}

#Create route table in us-west-2
resource "aws_route_table" "internet-route-oregon" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.vpc-worker-oregon.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-oregon.id
  }
  route {
    cidr_block                = "10.0.1.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.useast1-userst2.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = join("_", ["Worker-Region-RT", var.environment])
  }
}

#Overwrite default route table of VPC(Worker) with our route table entries
resource "aws_main_route_table_association" "set-worker-default-rt-assoc" {
  provider       = aws.region-worker
  vpc_id         = aws_vpc.vpc-worker-oregon.id
  route_table_id = aws_route_table.internet-route-oregon.id
}
