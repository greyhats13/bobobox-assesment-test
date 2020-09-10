/* ======================= VARIABLE PROVIDER AWS ======================= */
variable "profile_network" {
  description = "AWS User account Profile Network"
  default     = "network"
}

variable "profile_staging" {
  description = "AWS User account Profile Staging"
  default     = "staging"
}

variable "profile_production" {
  description = "AWS User account Profile Production"
  default     = "production"
}

variable "region" {
  default = "us-east-2"
}

variable "aws_credentials" {
  default = "./.aws/credentials"
}

/* ======================= END PROVIDER ======================= */

variable "nodes_route_table_id" {
  type = list(string)
  description = "Nodes Route Table ID value from module VPC"
}

variable "destination_cidr_block" {
  default     = "10.23.0.0/16"
  description = "Route destination to exercise SOA OnPremise"
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID from module TGW"
}

variable "tgw_vpc_stg_attachment_id" {
  description = "Transit Gateway VPC Attachment ID"
}

variable "tgw_vpn_attachment_id" {
  description = "Transit Gateway VPC Attachment ID"
}