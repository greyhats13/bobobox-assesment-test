#
# Variables Configuration
#
variable "cluster-name" {}

variable "vpc_id" {
  description = "VPC ID "
}

variable "apps_subnet" {
  description = "Apps subnet ids"
  type        = list(string)
}

variable "nodes_subnet" {
  type = list(string)
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of all subnet in cluster"
}

#variable "kubernetes-server-instance-sg" {
#  description = "Kubenetes control server security group"
#}

variable "instance-autoscaling-type" {}