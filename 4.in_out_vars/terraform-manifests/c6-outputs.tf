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

# For loop with list

output "for_output_list" {
    description = "Foor loop with list"
    value = [for instance in aws_instance.myVM: instance.public_dns]
}

# For loop with map

output "for_output_map1" {
    description = "Foor loop with map"
    value = {for instance in aws_instance.myVM:
            instance.id => instance.public_dns
            }
}

# For loop with map Advanced
output "for_output_map2" {
    description = "Foor loop with map - Advanced"
    value = {for each, instance in aws_instance.myVM:
            each => instance.public_dns
            }
}

#Output Legacy splat operator (Legacy) Returns the list

output "legacy_splat_instance_publicdns" {
    description = "Legacy splat operator"
    value = aws_instance.myVM.*.public_dns 
}

#Output latest generalized splat operator - Returns the List
output "latest_splat_instance_publicdns" {
    description = "Generalized latest splat operator"
    value = aws_instance.myVM[*].public_dns 
}






