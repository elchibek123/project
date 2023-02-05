variable "instance_type" {
    type = string
    description = "this is a size of EC2 instance"
    default = "t2.micro"
}

variable "key_name" {
    type = string
    description = "this is a  public key"
    default = "Key"
}

variable "ami" {
    type = string
    description = "this is image id"
    default = "ami-09ac9f3f161cbffe7"
}

variable "ingress_port" {
    type = list(string)
    description = "this is for ingress ports"
    default = ["22", "5000", "80"] 
}

variable "vpc_id" {
    type = string
    description = "this is vpc"
    default = "vpc-23652242352"
}

variable "subnet_id" {
    type = string
    description = "this is subnet id for ec2"
    default = "subnet-05463576372"
}

variable "env" {
  type        = string
  description = "this represents environment"
  default     = "dev"
}

variable "rds_subnet_id" {
    type = string
    description = "this is subnet id for rds"
    default = "subnet-0245635685245"
}

variable "rds_subnet_id_2" {
    type = string
    description = "this is subnet id for rds"
    default = "subnet-6548759806534"
}

variable "db_user" {
  type        = string
  description = "this represents db user"
  default     = "akumouser"
}