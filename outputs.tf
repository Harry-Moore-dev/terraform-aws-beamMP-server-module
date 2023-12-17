output "server_ip" {
  description = "public IP of the EC2 instance used for direct connect"
  value       = module.ec2.public_ip
}
