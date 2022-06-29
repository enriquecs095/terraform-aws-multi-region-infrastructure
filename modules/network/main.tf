#Create VPCs
resource "aws_vpc" "vpcs" {
  provider             = aws.region
  cidr_block           = var.vpcs.cidr_block
  enable_dns_support   = var.vpcs.dns_support
  enable_dns_hostnames = var.vpcs.dns_hostname
  tags = {
    Name = "vpc_${var.name}_${var.environment}"
  }
}

#Create internet gateways
resource "aws_internet_gateway" "igws" {
  provider = aws.region
  vpc_id   = aws_vpc.vpcs.id
  tags = {
    Name = "gateway_${var.name}_${var.environment}"
  }
}

data "aws_availability_zones" "azs" {
  provider = aws.region
  state    = "available"
}

#Create subnets
resource "aws_subnet" "subnets" {
  provider = aws.region
  vpc_id = aws_vpc.vpcs.id
  for_each = {
    for subnet in var.subnets : subnet.id => subnet
  }
  availability_zone = element(data.aws_availability_zones.azs.names, each.value.availability_zone)
  cidr_block        = each.value.cidr_block
  tags = {
    Name = "subnet_${var.name}_${var.environment}"
  }
}

#Create route tables
resource "aws_route_table" "internet-route" {
  provider = aws.region
  vpc_id   = aws_vpc.vpcs.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igws.id
  }
  route {
    cidr_block                = var.cidr_block_route_table
    vpc_peering_connection_id = var.peering_connection_id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "route_table_${var.name}_${var.environment}"
  }
}

#Overwrite default route table of VPCs with our route table entries 
resource "aws_main_route_table_association" "set-master-default-rt-assoc" {
  provider       = aws.region
  vpc_id         = aws_vpc.vpcs.id
  route_table_id = aws_route_table.internet-route.id
}
