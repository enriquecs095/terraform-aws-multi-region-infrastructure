/*
output "Jenkins-Worker-Public-IPs" {
  description = "The public ip of the instances"
  value = {
    for instance in aws_instance.instance :
    instance.id => instance.public_ip
  }
}
*/

output "private_ips" {
  description = "The private ip of the instances"
    value = {
    for instance in aws_instance.instances :
    instance.tags.Name => instance.private_ip 
  }
}