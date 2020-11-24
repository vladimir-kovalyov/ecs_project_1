resource "aws_instance" "mike_al_web" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.mike_al_VPC_Subnet.id
    vpc_security_group_ids = [ aws_security_group.mike_al_VPC_Security_Group.id ]

    tags = {
        "Name" = "Mike-Al Web"
    }
}

output "public_ip" {
  value = aws_instance.mike_al_web.public_ip
}

output "public_dns" {
  value = aws_instance.mike_al_web.public_dns
}