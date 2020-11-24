# create the VPC
resource "aws_vpc" "mike_al_VPC" {
  cidr_block           = var.vpcCIDRblock

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

# Create the Internet Gateway
resource "aws_internet_gateway" "mike_al_VPC_GW" {
 vpc_id = aws_vpc.mike_al_VPC.id
 tags = {
    Name = "Mike-Al VPC Internet Gateway"
 }
} # end resource

# Create the Route Table
resource "aws_route_table" "mike_al_VPC_route_table" {
 vpc_id = aws_vpc.mike_al_VPC.id
 tags = {
    Name = "Mike-Al VPC Route Table"
 }
} # end resource

# Create the Internet Access
resource "aws_route" "mike_al_VPC_internet_access" {
  route_table_id         = aws_route_table.mike_al_VPC_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.mike_al_VPC_GW.id
} # end resource

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "mike_al_VPC_association" {
  subnet_id      = aws_subnet.mike_al_VPC_Subnet.id
  route_table_id = aws_route_table.mike_al_VPC_route_table.id
} # end resource

output "subnet_id" {
    value = aws_subnet.mike_al_VPC_Subnet.id
}

output "vpc_security_group_id" {
    value = aws_security_group.mike_al_VPC_Security_Group.id
}