variable "region" {
    default = "eu-west-1"
}

variable "ami" {
    default = "ami-014ce76919b528bff"
}
variable "instance_type" {
    default = "t2.micro"
}

variable "vpcCIDRblock" {
    default = "10.0.0.0/16"
}
variable "subnetCIDRblock" {
    default = "10.0.1.0/24"
}
variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
    default = true
}

variable "availabilityZone" {
    default = "eu-west-1a"
}