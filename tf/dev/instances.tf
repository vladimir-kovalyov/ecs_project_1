/* resource "aws_launch_configuration" "mike_al_launch_config" {
  name_prefix                 = "mike_al_cluster"
  image_id                    = var.ami
  instance_type               = var.instance_type

  enable_monitoring           = true
  associate_public_ip_address = true
  
  lifecycle {
    create_before_destroy = true
  }

  # This user data represents a collection of “scripts” that will be executed the first time the machine starts.
  # This specific example makes sure the EC2 instance is automatically attached to the ECS cluster that we create earlier
  # and marks the instance as purchased through the Spot pricing
  user_data = <<EOF
    #!/bin/bash
    echo ECS_CLUSTER=mike_al_cluster >> /etc/ecs/ecs.config
    echo ECS_INSTANCE_ATTRIBUTES={\"purchase-option\":\"spot\"} >> /etc/ecs/ecs.config
    EOF

  # We’ll see security groups later
  security_groups = [
    aws_security_group.sg_for_ec2_instances.id
  ]

  # If you want to SSH into the instance and manage it directly:
  # 1. Make sure this key exists in the AWS EC2 dashboard
  # 2. Make sure your local SSH agent has it loaded
  # 3. Make sure the EC2 instances are launched within a public subnet (are accessible from the internet)
  key_name             = "mike-al-keypair"
}

# Allow EC2 instances to receive HTTP/HTTPS/SSH traffic IN and any traffic OUT
resource "aws_security_group" "sg_for_ec2_instances" {
  name_prefix = "mike_al_cluster_sg_for_ec2_instances_"
  description = "Security group for EC2 instances within the cluster"
  vpc_id = aws_vpc.mike_al_VPC.id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "mike_al_cluster"
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.sg_for_ec2_instances.id
}

resource "aws_security_group_rule" "allow_http_in" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_for_ec2_instances.id
  to_port           = 80
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  type = "ingress"
}

resource "aws_security_group_rule" "allow_https_in" {
  protocol  = "tcp"
  from_port = 443
  to_port   = 443
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.sg_for_ec2_instances.id
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_egress_all" {
  security_group_id = aws_security_group.sg_for_ec2_instances.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
  "0.0.0.0/0"]
} */

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