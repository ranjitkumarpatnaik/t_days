# Resource: EC2 instance
resource "aws_instance" "myVM" {
    ami = data.aws_ami.amzlinux2.id
    instance_type = var.instance_type
    #instance_type = var.instance_type_list[1] #for list
    #instance_type = var.instance_type_map["dev"] #for map
    key_name = var.instance_keypair
    vpc_security_group_ids = [ aws_security_group.vpc-ssh.id , aws_security_group.vpc-web.id ]
    user_data = file("${path.module}/app1-install.sh")
    count = 1 #creates 2 instances
    tags = {
      "Name" = "DemoVM-${count.index}"
    }
}