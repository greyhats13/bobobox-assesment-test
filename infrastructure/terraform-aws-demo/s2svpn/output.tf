output "s2svpn_id" {
  value = aws_vpn_connection.s2svpn_exercise.id
}

output "customer_gateway_id" {
  value = aws_vpn_connection.s2svpn_exercise.customer_gateway_id 
}

output "tgw_vpn_attachment_id" {
  value = aws_vpn_connection.s2svpn_exercise.transit_gateway_attachment_id
}