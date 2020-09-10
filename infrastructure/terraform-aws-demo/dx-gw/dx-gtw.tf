resource "aws_dx_gateway" "exercise_dxgw" {
  name            = var.dxgw_name
  amazon_side_asn = var.dxgw_asn
}