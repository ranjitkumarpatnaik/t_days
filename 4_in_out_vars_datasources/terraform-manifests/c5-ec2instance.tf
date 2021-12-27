# Resource: EC2 instance
resource "aws_instance" "myVM" {
    ami = data.aws_ami.amzlinux2.id
    instance_type = var.instance_type
    key_name = var.instance_keypair
    vpc_security_group_ids = [ aws_security_group.vpc-ssh.id , aws_security_group.vpc-web.id ]
    user_data = file("${path.module}/app1-install.sh")

    tags = {
      "Name" = "DemoVM"
    }
}