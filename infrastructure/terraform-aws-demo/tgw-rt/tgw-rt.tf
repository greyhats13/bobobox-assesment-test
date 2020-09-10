#Provider untuk akun staging
provider "aws" {
  alias                   = "staging"
  region                  = var.region
  profile                 = var.profile_staging
  shared_credentials_file = var.aws_credentials
}

#Provider untuk akun production
# provider "aws" {
#   alias                   = "production"
#   region                  = var.region
#   profile                 = var.profile_production
#   shared_credentials_file = var.aws_credentials
# }

//Add routing to TGW network in 3 Nodes Routing table from Staging account
resource "aws_route" "nodes_rt_route_tgw_network_stg" {
  provider               = aws.staging
  count                  = length(var.nodes_route_table_id)
  route_table_id         = element(var.nodes_route_table_id, count.index)
  destination_cidr_block = var.destination_cidr_block
  transit_gateway_id     = var.transit_gateway_id
}


#Transit Gateway Route Table for VPC both Staging and Production
resource "aws_ec2_transit_gateway_route_table" "tgw_rt_vpc" {
  transit_gateway_id = var.transit_gateway_id
  tags = {
    Name = "TGW RT VPC STG TF"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_vpc_stg_associate" {
  transit_gateway_attachment_id  = var.tgw_vpc_stg_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt_vpc.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_vpc_propagation" {
  transit_gateway_attachment_id  = var.tgw_vpn_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt_vpc.id
}

resource "aws_ec2_transit_gateway_route_table" "tgw_rt_s2svpn" {
  transit_gateway_id = var.transit_gateway_id
  tags = {
    Name = "TGW RT S2S VPN TF"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_s2svpn_associate" {
  transit_gateway_attachment_id  = var.tgw_vpn_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt_s2svpn.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_vpn_propagation" {
  transit_gateway_attachment_id  = var.tgw_vpc_stg_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt_s2svpn.id
}