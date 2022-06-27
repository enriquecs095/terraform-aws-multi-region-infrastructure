output "peering_connection_id" {
  description = "Id of the peering connection"
  value       = aws_vpc_peering_connection.useast1-userst2.id
}
