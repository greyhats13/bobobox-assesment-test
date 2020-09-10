variable "bgp_asn" {
  type        = number
  default     = 65000
  description = "BGP ASN from network account"
}

variable "ip_address" {
  default     = "202.152.224.2"
  description = "exercise Customer Gateway IP address"
}

variable "type" {
  default     = "ipsec.1"
  description = "exercise Customer Gateway Type e.g ipsec.1"
}

variable "cgw_tags" {
  default = {
    Name = "exercise Customer Gateway TF"
    Env  = "Network"
  }
}


