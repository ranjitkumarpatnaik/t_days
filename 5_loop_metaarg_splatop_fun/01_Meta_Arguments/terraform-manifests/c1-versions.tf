##########Terraform Block#############
terraform {
    #Required Terraform Versions
    required_version = "~> 0.13"
    required_providers {
      aws = {  #Local name of our provider (model specific and should be uique per module)
        source = "hashicorp/aws"
        version = "~> 3.0"
       }
    }
}

###########--Provider Block--###########
provider "aws" {
    region = var.aws_region
}


