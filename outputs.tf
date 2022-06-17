
/*
output "Jenkins-Main-Node-Public-IP" {
  value = module.ec2_instance_1.public_ip
}

output "Jenkins-Worker-Public-IPs" {
  value = {
    for module in module.ec2_instance_2 :
    module.id => module.public_ip
  }
}*/

/*
output "LB-DNS-NAME" {
  value = aws_lb.application-lb.dns_name
}

output "url" {
  value = aws_route53_record.jenkins.fqdn

}*/