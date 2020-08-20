locals {
  vnetpeer_first  = "${var.client_name}-${var.environment}-${var.location}-peerf2s-${var.role}"
  vnetpeer_second = "${var.client_name}-${var.environment}-${var.location}-peers2f-${var.role}"

}
