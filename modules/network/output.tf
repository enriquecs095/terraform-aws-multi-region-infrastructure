output "subnet_1_id" {
  description = "The id of the subnet 1 in us-east-1"
  value       = aws_subnet.subnet-1.id

}

output "subnet_1_oregon_id" {
  description = "The id of the subnet 1 in us-west-2"
  value       = aws_subnet.subnet-1-oregon.id
}

output "vpc_1_id" {
  description = "The id of the vpc  in us-west-2"
  value       = aws_vpc.vpc-master.id

}

output "vpc_1_oregon_id" {
  description = "The id of the vpc in us-west-2"
  value       = aws_vpc.vpc-worker-oregon.id

}
