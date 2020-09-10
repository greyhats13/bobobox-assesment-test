#Create Ttransit Gateway in Network account
resource "aws_ec2_transit_gateway" "tgw_exercise" {
  description                     = var.tgw_description
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  dns_support                     = var.dns_support
  vpn_ecmp_support                = var.vpn_ecmp_support
  tags                            = var.tgw_tags
}

