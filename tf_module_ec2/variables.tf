variable "ami" {
  type        = string
  description = "This is AMI for EC2 Ubuntu 20.04 instance in us-east-1 (shs)"
  default     = "ami-09ac9f3f161cbffe7"
}
variable "instance_type" {
  type        = string
  description = "The size of EC2"
  default     = "t2.micro"
}
variable "key-name" {
  type        = string
  description = "This is a key to SSH to instance"
  default     = "Key"
}

# Naming and Tagging

variable "environment" {
  type        = string
  description = "This is an environment"
}
variable "product-name" {
  type        = string
  description = "This is a name of your product"
}
variable "resource-number" {
  type        = string
  description = "This is a number of resource"
}
variable "owner-id" {
  type        = string
  description = "This is owner id"
}
variable "owner-contact" {
  type        = string
  description = "This is owner contact"
}
variable "project" {
  type        = string
  description = "This is a project name"
}
variable "team" {
  type        = string
  description = "This is a team name"
}
variable "managed-by" {
  type        = string
  description = "This defines who manages a resource"
  default     = "terraform"
}

# Network

variable "vpc" {
  type        = string
  description = "This is VPC id"
  default     = "vpc-02098852956be6d09"
}
variable "subnet" {
  type        = string
  description = "This is subnet id in us-east-1a"
  default     = "subnet-00277a405bdda7d9d"
}