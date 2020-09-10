output "cgw_id" {
  value = aws_customer_gateway.cgw_exercise.id
}

output "cgw_bgp_asn" {
  value = aws_customer_gateway.cgw_exercise.bgp_asn
}

output "cgw_ip_address" {
  value = aws_customer_gateway.cgw_exercise.ip_address
}

output "cgw_type" {
  value = aws_customer_gateway.cgw_exercise.type
}

output "cgw_tags" {
  value = aws_customer_gateway.cgw_exercise.tags
}
