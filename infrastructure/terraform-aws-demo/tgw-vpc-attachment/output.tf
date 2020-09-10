output "tgw_vpc_stg_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_vpc_creator_stg.id
}

output "tgw_attachment_vpc_stg_owner_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_vpc_creator_stg.vpc_owner_id
}
