output "vpc_id" {
  description = "The id of the vpc"
  value       = aws_vpc.vpcs.id
}

output "subnets_id" {
  description = "The id of the subnets"
  value = {
    for subnet in aws_subnet.subnets :
    subnet.tags.Name => subnet.id
  }
}

output "security_groups_id" {
  description = "The id of the security groups"
  value = {
    for sg in aws_security_group.security_groups :
    sg.name => sg.id
  }
}

output "route_tables_resource" {
  description = "The route table resource"
  value       = aws_route_table.internet-routes
}
