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