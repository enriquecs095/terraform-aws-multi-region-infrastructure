
output "public_ips" {
  description = "The public ip of the instances"
  value = {
    for instance in aws_instance.instances :
    instance.id => instance.public_ip
  }
}

output "private_ips" {
  description = "The private ip of the instances"
    value = {
    for instance in aws_instance.instances :
    instance.tags.Name => instance.private_ip 
  }
}

output "instances_id" {
  description = "The id of the instances"
    value = {
    for instance in aws_instance.instances :
    instance.tags.Name => instance.id 
  }
}
