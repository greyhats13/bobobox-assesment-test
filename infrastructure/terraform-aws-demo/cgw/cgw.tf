resource "aws_customer_gateway" "cgw_exercise" {
  bgp_asn    = var.bgp_asn
  ip_address = var.ip_address
  type       = var.type
  tags       = var.cgw_tags
}
