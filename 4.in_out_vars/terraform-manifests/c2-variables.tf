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

# AWS EC2 Instance Type List

variable "instance_type_list" {
  description = "EC2 instance type"
  type = list(string)
  default = ["t2.micro","t2.small","t2.large"]
}

# AWS EC2 Instance Type map

variable "instance_type_map" {
  description = "EC2 instance type"
  type = map(string)
  default = {
    "dev" = "t2.micro"
    "qa" = "t2.small"
    "prod" = "t2.large"

  }
}



#AWS Ec2 instance key pair

variable "instance_keypair" {
    description = "EC2 key pair that needs to be associated with ec2 instance"
    type = string
    default = "DevopsProject"
  
}














