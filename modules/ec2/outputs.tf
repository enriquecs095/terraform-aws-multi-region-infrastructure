/*
output "Jenkins-Worker-Public-IPs" {
  description = "The public ip of the instances"
  value = {
    for instance in aws_instance.instance :
    instance.id => instance.public_ip
  }
}

output "master_private_ip" {
  description = "The private ip of the master instance"
    value = {
    for instance in aws_instance.instance :
    instance.id => instance.private_ip
  }
}*/