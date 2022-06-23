output "Jenkins-Main-Node-Public-IP" {
  description = "The public ip of the instance 1 in us-east-1"
  value       = module.instances-infrastructure.Jenkins-Main-Node-Public-IP
}

output "Jenkins-Worker-Public-IPs" {
  description = "The public ips of the instances in us-west-2"
  value = module.instances-infrastructure.Jenkins-Worker-Public-IPs
}

output "alb_dns_name" {
  description = "The DNS name of the application load balancer in us-east-1"
  value       = module.load-balancer-infrastructure.alb_dns_name
}

output "url" {
  description = "The url of the dns server"
  value       = module.acm-infrastructure.url
}
