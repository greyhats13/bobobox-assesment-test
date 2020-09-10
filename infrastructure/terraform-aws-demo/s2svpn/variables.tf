variable "customer_gateway_id" {
  description = "Customer Gateway ID value from module cgw"
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID value from module tgw"
}

variable "customer_gateway_type" {
  description = "Customer Gateway types value from module cgw"
}

variable "static_routes_only" {
  type = bool
  default = false
  description = "Routing type wheter dynamic or static"
}

variable "s2svpn_tags" {
  type = map(string)
  default = {
    Name = "exercise S2S VPN TF"
    Env = "Network"
  }
  description = "exercise Site to Site VPN tags"
}
