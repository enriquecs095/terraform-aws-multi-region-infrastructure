output "Jenkins-Main-Node-Public-IP" {
  description = "The public ip of the instance 1 in us-east-1"
  value       = aws_instance.jenkins-master.public_ip
}

output "instance_1_master_id" {
  description = "The id of the instance 1 in us-east-1"
  value       = aws_instance.jenkins-master.id
}

output "Jenkins-Worker-Public-IPs" {
  description = "The public ips of the instances in us-west-2"
  value = {
    for instance in aws_instance.jenkins-worker-oregon :
    instance.id => instance.public_ip
  }
}


