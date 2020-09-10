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


#VPC
variable "create_vpc" {
  default = ""
}

variable "cluster_name" {
  description = "Cluster name"
}

variable "vpc_name" {}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

#subnet variable
variable "nodes_subnet_cidr" {
  type        = list(string)
  description = "CIDR for master subnet"
  # default     = []
}

variable "apps_subnet_cidr" {
  type        = list(string)
  description = "CIDR for worker subnet"
  # default     = []
}

variable "public_subnet_cidr" {
  description = "Kubernetes Public CIDR"
  type        = list(string)
}

variable "cache_subnet_cidr" {
  type        = list(string)
  description = "Kubernetes Cache CIDR"
  # default     = []
}

variable "allocation_id" {}
