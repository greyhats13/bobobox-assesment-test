resource "aws_vpn_connection" "s2svpn_exercise" {
  customer_gateway_id   = var.customer_gateway_id
  transit_gateway_id    = var.transit_gateway_id
  type                  = var.customer_gateway_type
  #use BGP (dynamic route)
  static_routes_only    = var.static_routes_only
  tags = var.s2svpn_tags
}
