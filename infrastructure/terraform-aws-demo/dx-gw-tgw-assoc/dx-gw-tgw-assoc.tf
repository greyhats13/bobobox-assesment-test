#Retrieve data from existing Direct Connect resource that has been attached to Direct Connect and Transit Virtual Interface
#Comment this data source if you are not using existing resource and create new one with Terraform
data "aws_dx_gateway" "exercise_dxgw" {
  name = "exerciseGateway1"
}

#Create Direct Connect Gateway and Transit Gateway Association
resource "aws_dx_gateway_association" "exercise_dx_tgw_assoc" {
  #Uncomment if you create new Direct Connect Gateway resource with terraform
  #dx_gateway_id         = var.dx_gateway_id
  #Comment if you create new Direct Connect Gateway resource with terraform, Uncomment if using existing resource
  dx_gateway_id         = data.aws_dx_gateway.exercise_dxgw.id
  associated_gateway_id = var.transit_gateway_id
  allowed_prefixes      = var.allowed_prefixes
}
