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

variable "tgw_description" {
  default = "exercise Transit Gateway Network"
}

variable "amazon_side_asn" {
  default     = 64512
  description = "Amazon Side ASN"
}

variable "auto_accept_shared_attachments" {
  default     = "disable"
  description = "automatically accept resources attachment"
}

variable "default_route_table_association" {
  default     = "enable"
  description = "set default route table associate to enable or disable"
}

variable "default_route_table_propagation" {
  default     = "enable"
  description = "set default route table propagation to enable or disable"
}

variable "dns_support" {
  default     = "enable"
  description = "set dns support to enable or disable"
}

variable "vpn_ecmp_support" {
  default     = "enable"
  description = "set vpn ecmp support to enable or disable"
}

variable "tgw_tags" {
  type = map(string)
  default = {
    Name = "TGW Network TF",
    Env  = "Network"
  }
  description = "Transit Gateway tags"
}
