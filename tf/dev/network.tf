# create the VPC
resource "aws_vpc" "mike_al_VPC" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames

  tags = {
      Name = "ma-acad-VPC"
  }
} # end resource

# create the Subnet
resource "aws_subnet" "mike_al_VPC_Subnet" {
  vpc_id                  = aws_vpc.mike_al_VPC.id
  cidr_block              = var.subnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone

  tags = {
     Name = "ma-acad-VPC-subnet"
  }
} # end resource

# Create the Security Group
resource "aws_security_group" "mike_al_VPC_Security_Group" {
  vpc_id       = aws_vpc.mike_al_VPC.id
  name         = "Mike-Al VPC Security Group"
  description  = "Mike-Al VPC Security Group"

# allow ingress of port 22
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

#   allow ingress of port 80
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Mike-Al VPC Security Group"
    Description = "Mike-Al VPC Security Group"
  }
} # end resource