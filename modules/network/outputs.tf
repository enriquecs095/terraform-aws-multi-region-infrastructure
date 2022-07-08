output "vpc_id" {
  description = "The id of the vpc"
  value       = aws_vpc.vpcs.id
}
/*
output "subnets_id" {
  description = "The id of the subnets"
  value = {
    for subnet in aws_subnet.subnets :
    subnet.id => subnet.name
  }
}
*/
