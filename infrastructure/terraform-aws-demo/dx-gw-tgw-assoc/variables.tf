variable "transit_gateway_id" {
  description = "Transit Gateway ID values from module tgw"
}

variable "allowed_prefixes" {
  type = list(string)
  default = [
    "10.23.0.0/16",
  ]
  description = "Allowed prefix in Transit Gateway association"
}