output "sg_1_master_id" {
  description = "The id of the security group 1 in us-east-1"
  value       = aws_security_group.jenkins-sg.id
}

output "sg_1_worker_oregon_id" {
  description = "The id of the security group 1 in us-west-2"
  value       = aws_security_group.jenkins-sg-oregon.id
}

output "sg_2_master_id" {
  description = "The id of the security group 2 in us-east-1"
  value       = aws_security_group.lb-sg.id
}
