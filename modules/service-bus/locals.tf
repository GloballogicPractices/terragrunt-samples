locals {
  sb_name = "${var.client_name}-${var.environment}-${var.location}-sb-${var.role}"

  env_tags = {
    "role"        = var.role
    "environment" = var.environment
    "owner"       = var.owner
    "vendor"      = var.vendor
    "application" = var.client_name
    "creator"     = var.creator
  }

  sb_tags = "${merge(local.env_tags, var.tags)}"
}
