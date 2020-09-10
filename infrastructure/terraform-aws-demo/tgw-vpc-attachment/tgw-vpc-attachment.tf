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

#Create RAM Resource Share in network account
resource "aws_ram_resource_share" "ram_tgw_stg" {
  name                      = var.ram_resource_share_name_stg
  allow_external_principals = var.allow_external_principals

  tags = {
    Name = "RAM in Production",
    Env  = "Staging"
  }
}

resource "aws_ram_resource_association" "share_tgw_stg" {
  resource_arn       = var.resource_arn
  resource_share_arn = aws_ram_resource_share.ram_tgw_stg.arn
}

data "aws_caller_identity" "stg_receiver" {
  provider = aws.staging
}


//Send resource TGW dari akun Network ke akun Staging
resource "aws_ram_principal_association" "assoc_tgw_stg" {
  principal          = data.aws_caller_identity.stg_receiver.account_id
  resource_share_arn = aws_ram_resource_share.ram_tgw_stg.arn
}

resource "aws_ram_resource_share_accepter" "stg_receiver_accept" {
  provider  = aws.staging
  share_arn = aws_ram_principal_association.assoc_tgw_stg.resource_share_arn
  #depends_on = [aws_ram_principal_association.send_tgw_stg, aws_ram_resource_share.ram_tgw_stg]
}

#Transit Gateway Attachment which has been shared to Staging account from Network Account
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_vpc_creator_stg" {
  provider                                        = aws.staging
  depends_on                                      = [aws_ram_principal_association.assoc_tgw_stg, aws_ram_resource_association.share_tgw_stg, aws_ram_resource_share_accepter.stg_receiver_accept]
  subnet_ids                                      = var.subnet_ids
  transit_gateway_id                              = var.transit_gateway_id
  vpc_id                                          = var.vpc_id
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation
  tags                                            = var.tgw_vpc_attachment_creator_tags
}

#Network account accept Transit Gateway Attachment from Staging account
resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "tgw_attachment_vpc_accepter_stg" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_vpc_creator_stg.id
  tags                          = var.tgw_vpc_attachment_accepter_tags
}
