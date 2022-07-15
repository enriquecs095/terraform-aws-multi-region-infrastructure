
output "subnets_master" {
  description = "The id of the subnets"
  value = module.master-network-infrastructure.subnets_id
}

output "subnets_worker" {
  description = "The id of the subnets"
  value = module.worker-network-infrastructure.subnets_id
}

output "security_groups_master" {
  description = "The id of the security groups"
  value = module.master-network-infrastructure.security_groups_id
}

output "security_groups_worker" {
  description = "The id of the security groups"
  value = module.worker-network-infrastructure.security_groups_id
}

output "Jenkins-Main-Node-Public-IP" {
  description = "The public ip of the instances in us-east-1"
  value       = module.ec2-master-infrastructure.public_ips
}

output "Jenkins-Worker-Public-IPs" {
  description = "The public ips of the instances in us-west-2"
  value = module.ec2-worker-infrastructure.public_ips
}

output "alb_dns_name" {
  description = "The DNS name of the application load balancer in us-east-1"
  value       = module.load-balancer-infrastructure.alb_dns_name
}

output "url" {
  description = "The url of the dns server"
  value       = module.acm-infrastructure.url
}
