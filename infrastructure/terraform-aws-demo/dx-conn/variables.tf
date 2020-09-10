#Direct Connect Variables
variable "dx_name" {
  default     = "exercise Direct Connect TF"
  description = "exercise Direct Connect Name"
}

variable "dx_bandwidth" {
  default     = "1Gbps"
  description = "exercise Direct Connect Bandwidth Size"
}

variable "dx_location" {
  #Location on Equinix Singapore
  default     = "EqSG2"
  description = "exercise Direct Connect Location"
}

variable "dx_tags" {
  type = map(string)
  default = {
    Env = "exercise Direct Connect in Network Account TF"
  }
  description = "exercise Direct Connect tags"
}
