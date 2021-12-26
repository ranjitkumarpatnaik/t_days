variable "subnet_prefix" {
  description = "cidr block for the subnet"
}

# Steps Involved:
# ===============

# 1.Create VPC
# 2.Create Internet Gateway
# 3.Create Custom Route Table
# 4.Create a subnet
# 5.Associate subnet with Route Table
# 6.Create security group to allow port 22,80,443
# 7.Create a network interface with an IP in the subnet that was created in step 4
# 8. Assign an elastic Ip to the network interface created in step 7
# 9. Create ubuntu server and insatll/enable apache2

# 1. Creating a VPC
resource "aws_vpc" "prod_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "production"
  }
}

# 2. Creating an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "prod_gateway"
  }
}

#3.Creating a cutom Route Table
resource "aws_route_table" "prod_route_table" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "prod_route"
  }
}

#4. Creating a Subnet where out webserver is going to reside on

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = var.subnet_prefix
    availability_zone = "ap-south-1a"
  
    tags = {
      "Name" = "prod_subnet"
    }
}

#5. Associate subnet with route table

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.prod_route_table.id
}

#6. Creating a Security Group to allow port 22,80,443

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

   ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web_traffic"
  }
}

#7. Creating a netwrok interface

resource "aws_network_interface" "webserver_nic" {
  subnet_id       = aws_subnet.subnet1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}

#8. Assign and eip to the nic in step7

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.webserver_nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.gw]
}

output "webserver_public_ip" {
  value = aws_eip.one.public_ip
  
}

#9.Create Ubuntu server and install/enable apache2
resource "aws_instance" "webserver" {
    ami = "ami-0851b76e8b1bce90b"
    instance_type = "t2.micro"
    availability_zone = "ap-south-1a" 
    key_name = "DevopsProject"
    
    network_interface {
      device_index = 0
      network_interface_id = aws_network_interface.webserver_nic.id 
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update-y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo My 1st WebServer > /var/www/html/index.html'
                EOF

    tags = {
      Name = "ubuntu_webserver"
    }
}
output "server_private_ip" {
  value = aws_instance.webserver.private_ip
}

output "server_id" {
  value = aws_instance.webserver.id
}