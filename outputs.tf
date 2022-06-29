output "aws_region_master" {
  description = "AWS region"
  value       = module.master-network-infrastructure.aws_region
}

output "aws_region_worker" {
  description = "AWS region"
  value       = module.worker-network-infrastructure.aws_region
}