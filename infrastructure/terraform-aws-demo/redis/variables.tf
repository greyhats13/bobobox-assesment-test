variable "cluster_id" {
  type        = string
  description = "Cluster Name for Elastic Cache Redis"
}

variable "engine" {
  type        = string
}

variable "node_type" {
  type        = string
  description = "Node"
}

variable "parameter_group_name" {
  type        = string
}

variable "engine_version" {
  type        = string
}

variable "port" {
  type  = number
}

variable "name_subnet_group" {
  type  = string
}

variable "subnet_ids" {
  type  = list(string)
}