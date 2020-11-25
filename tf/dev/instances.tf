/* resource "aws_instance" "mike_al_web" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = "mike-al-keypair"
    connection {
        type     = "ssh"
        user     = "ec2-user"
        private_key = file("~/.ssh/mike-al-keypair.pem")
        host     = "self.public_ip"
    }
    subnet_id = aws_subnet.mike_al_VPC_Subnet.id
    vpc_security_group_ids = [ aws_security_group.mike_al_VPC_Security_Group.id ]
    user_data = <<-EOF
            #!/bin/bash
            sudo yum -y install httpd
            sudo chmod 777 /var/www/html/
            sudo systemctl enable httpd
            sudo systemctl start httpd
            echo "<h1>Hello Al</h1>" > /var/www/html/index.html
            EOF

    tags = {
        "Name" = "Mike-Al Web"
    }
}

output "public_ip" {
  value = aws_instance.mike_al_web.public_ip
}

output "public_dns" {
  value = aws_instance.mike_al_web.public_dns
} */