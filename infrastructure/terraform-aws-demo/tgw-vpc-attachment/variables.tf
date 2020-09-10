/* ======================= VARIABLE PROVIDER AWS ======================= */
variable "profile_network" {
  description = "AWS User account Profile"
  default     = "network"
}

variable "profile_staging" {
  description = "AWS User account Profile"
  default     = "staging"
}

variable "profile_production" {
  description = "AWS User account Profile"
  default     = "production"
}

variable "region" {
  default = "us-east-2"
}

variable "aws_credentials" {
  default = "./.aws/credentials"
}

/* ======================= END PROVIDER AWS ======================= */

variable "ram_tags" {
  default = {
    Name = "RAM",
    Env  = "Network"
  }
  description = "RAM tags"
}

#staging
variable "ram_resource_share_name_stg" {
  default = "RAM Resource Share TGW TO STG TF"
  description = "RAM resource to share Transit Gateway from AWS Network account to AWS staging account"
}

variable "ram_resource_share_name_prod" {
  default = "RAM Resource Share TGW TO PROD TF"
  description = "RAM resource to share Transit Gateway from AWS Network account to AWS production account"
}

variable "allow_external_principals" {
  default = true
}

variable "resource_arn" {
  description = "Resource ARN of Transit Gateway created in network account"
}

variable "tgw_vpc_attachment_creator_tags" {
  type = map(string)
  default = {
    Name = "TGW VPC Attachment Creator STG TF",
    Side = "Creator",
    Env  = "Staging"
  }
}

variable "transit_gateway_id" {
  description = "transit gateway id from module transit gateway"
}

variable "subnet_ids" {
  description = "Nodes subnet ids from module VPC staging"
}

variable "vpc_id" {
  description = "vpc id from module VPC staging"
}

variable "transit_gateway_default_route_table_association" {
  default = true
}

variable "transit_gateway_default_route_table_propagation" {
  default = true
}

variable "tgw_vpc_attachment_accepter_tags" {
  type = map(string)
  default = {
    Name = "TGW VPC Attachment Accept STG TF",
    Side = "Accepter",
    Env  = "Network"
  }
}
