locals {
  rg_name = "${var.client_name}-${var.environment}-${var.location}-rg-${var.role}"

  env_tags = {
    "role"        = var.role
    "environment" = var.environment
    "owner"       = var.owner
    "vendor"      = var.vendor
    "application" = var.client_name
    "creator"     = var.creator
  }

  rg_tags = "${merge(local.env_tags, var.tags)}"
}
