#Input Variables
# AWS Region

variable "aws_region" {
    description = "Region in which aws resource is to be created"
    type = string
    default = "ap-south-1"  
}

# AWS EC2 Type
variable "instance_type" {
    description = "EC2 Instance type"
    type = string
    default = "t2.micro"
  
}

#AWS Ec2 instance key pair

variable "instance_keypair" {
    description = "EC2 key pair that needs to be associated with ec2 instance"
    type = string
    default = "DevopsProject"
  
}






