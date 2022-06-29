output "vpc_id" {
  description = "The id of the vpc"
  value       = aws_vpc.vpcs.id
}

output "aws_region" {
  description = "AWS region"
  value       = data.aws_availability_zones.azs.names
}