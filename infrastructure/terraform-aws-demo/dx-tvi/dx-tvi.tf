resource "aws_dx_transit_virtual_interface" "exercise_dx_tvi" {
  #depends_on       = [aws_dx_connection.exercise_dx, aws_dx_gateway.exercise_dxgw]
  connection_id    = var.dx_connection_id
  dx_gateway_id    = var.dx_gateway_id
  name             = var.exercise_dx_tvi_name
  vlan             = var.exercise_dx_tvi_vlan
  address_family   = var.exercise_dx_tvi_address_family
  bgp_asn          = var.exercise_dx_tvi_bgp_asn
  amazon_address   = var.exercise_dx_tvi_amazon_address
  bgp_auth_key     = var.exercise_dx_tvi_bgp_auth_key
  customer_address = var.exercise_dx_tvi_customer_address
  mtu              = var.exercise_dx_tvi_mtu
  tags             = var.exercise_dx_tvi_tags
}