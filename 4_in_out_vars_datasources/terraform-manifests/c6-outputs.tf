# Terraform Output Values

# EC2 Instacne Public IP
output "instance_public_ip" {
    description = "EC2 instance Public IP"
    value = aws_instance.myVM.public_ip
}

# EC2 Instance Public DNS
output "instance_publicip" {
    description = "EC2 instance Public IP"
    value = aws_instance.myVM.public_dns
}