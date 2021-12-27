# Resource: EC2 instance
resource "aws_instance" "myVM" {
    ami = "ami-052cef05d01020f1d"
    instance_type = "t2.micro"
    tags = {
      "Name" = "DemoVM"
    }
}