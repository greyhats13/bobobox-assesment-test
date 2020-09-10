/* =================== OUTPUT TGW exercise =================== */
output "arn" {
  value = aws_ec2_transit_gateway.tgw_exercise.arn
}

output "association_default_route_table_id" {
  value = aws_ec2_transit_gateway.tgw_exercise.association_default_route_table_id
}

output "id" {
  value = aws_ec2_transit_gateway.tgw_exercise.id
}

output "owner_id" {
  value = aws_ec2_transit_gateway.tgw_exercise.arn
}

output "propagation_default_route_table_id" {
  value = aws_ec2_transit_gateway.tgw_exercise.arn
}
/* =================== END TGW exercise =================== */