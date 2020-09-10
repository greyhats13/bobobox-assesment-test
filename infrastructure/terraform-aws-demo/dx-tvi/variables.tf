variable "dx_connection_id" {
  description = "Direct Connect Connection ID from module dx-conn"
}

variable "dx_gateway_id" {
  description = "Direct Connect Gateway ID from module dx-gw"
}

variable "exercise_dx_tvi_name" {
  default     = "exercise Transit Virtual Interface TF"
  description = "Direct Connect Transit Virtual Interface Name"
}

variable "exercise_dx_tvi_vlan" {
  type        = number
  default     = 432
  description = "Direct Connect Transit Virtual Interface VLAN"
}

variable "exercise_dx_tvi_address_family" {
  default     = "ipv4"
  description = "Direct Connect Transit Virtual Interface VLAN"
}

variable "exercise_dx_tvi_bgp_asn" {
  type        = number
  default     = 65287
  description = "Direct Conenct Transit Virtual Interface BGP ASN"
}

variable "exercise_dx_tvi_amazon_address" {
  default     = "10.23.3.106/30"
  description = "Direct Conenct Transit Virtual Interface Amazon Router Peer Address"
}

variable "exercise_dx_tvi_bgp_auth_key" {
  default     = "0x1tDY269l3xHIMiG4t7HsVj"
  description = "Direct Conenct Transit Virtual Interface BGP Authorization Key"
}


variable "exercise_dx_tvi_customer_address" {
  default     = "10.23.3.105/30"
  description = "Direct Conenct Transit Virtual Interface Customer Router Peer Address"
}

variable "exercise_dx_tvi_mtu" {
  type        = number
  default     = 8500
  description = "Direct Conenct Transit Virtual Interface MTU"
}

variable "exercise_dx_tvi_tags" {
  type = map(string)
  default = {
    company           = "Bebas - exercise",
    "Router Location" = "Equinix Singapore"
  }
  description = "Direct Connect Transit Virtual Interface tags"
}