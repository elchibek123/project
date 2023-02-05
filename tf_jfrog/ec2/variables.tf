variable "instance_type" {
    type = string
    description = "this is a size of EC2"
    default = "t2.medium"
}

variable "key_name" {
    type = string
    description = "this is a  public key"
    default = "Key"
}

variable "ami" {
    type = string
    description = "this is image id"
    default = "ami-0be26d5a8201ff437"
}

variable "ingress_port" {
    type = list(string)
    description = "this is for ingress ports"
    default = ["22", "80", "443", "8082"] 
}

variable "vpc_id" {
    type = string
    description = "this is vpc"
    default = "vpc-0457247245645265"
}

variable "subnet_id" {
    type = string
    description = "this is subnet id"
    default = "subnet-54727245j436324"
}