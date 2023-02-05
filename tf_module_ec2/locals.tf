locals {
  common_tags = {
    OwnerID      = var.owner-id
    OwnerContact = var.owner-contact
    Project      = var.project
    Environment  = var.environment
    Team         = var.team
    ManagedBy    = var.managed-by
  }
  ssh-port = 22
}