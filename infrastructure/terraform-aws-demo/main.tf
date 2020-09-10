provider "aws" {
  region                  = var.region
  profile                 = var.profile_network
  shared_credentials_file = var.aws_credentials
}

//Provider untuk akun staging
provider "aws" {
  alias                   = "staging"
  region                  = var.region
  profile                 = var.profile_staging
  shared_credentials_file = var.aws_credentials
}

provider "aws" {
  alias                   = "production"
  region                  = var.region
  profile                 = var.profile_production
  shared_credentials_file = var.aws_credentials
}

# VPC - Production & Staging
module "vpc" {
  source             = "./vpc"
  cidr               = var.vpc-cidr-block
  vpc_name           = var.vpc_name
  cluster_name       = var.cluster-name
  allocation_id      = var.eip-nat
  apps_subnet_cidr   = var.apps-cidr
  cache_subnet_cidr  = var.cache-cidr
  nodes_subnet_cidr  = var.nodes-cidr
  public_subnet_cidr = var.public-cidr
}

#Module Transit Gateway Network account
module "tgw" {
  source = "./tgw"
}

#Module Resource Access Manager - Transit Gateway Attachment
module "tgw-vpc-attachment" {
  source             = "./tgw-vpc-attachment"
  subnet_ids         = flatten([module.vpc.nodes_subnet])
  resource_arn       = module.tgw.arn
  transit_gateway_id = module.tgw.id
  vpc_id             = module.vpc.vpc_id
}

#Module Customer Gateway
module "cgw" {
  source = "./cgw"
}

#Module Site to Site VPN
module "s2svpn" {
  source                = "./s2svpn"
  customer_gateway_id   = module.cgw.cgw_id
  transit_gateway_id    = module.tgw.id
  customer_gateway_type = module.cgw.cgw_type
}

#Module Direct Connect -  Uncomment if you create new resources with Terraform
module "dx-conn" {
  source = "./dx-conn"
}

Module Direct Connect Gateway -  Uncomment if you create new resources with Terraform
module "dx-gw" {
  source = "./dx-gw"
}

Module Direct Connect Transit Virtual Interface -  Uncomment if you create new resources with Terraform
module "dx-tvi" {
  source           = "./dx-tvi"
  dx_connection_id = module.dx-conn.exercise_dx_id
  dx_gateway_id    = module.dx-gw.exercise_dx_gateway_id
}

#Module Direct Connect Gateway and Transit Gateway association -  Uncomment if you create new resources with Terraform
module "dx-gw-tgw-assoc" {
  source = "./dx-gw-tgw-assoc"
  #Uncomment if you create new resource of Direct Connect Gateway
  #dx_gateway_id      = module.dx-gw.exercise_dx_gateway_id
  transit_gateway_id = module.tgw.id
}

#Module Transit Gateway Route Table from Network account
module "tgw-rt" {
  source                    = "./tgw-rt"
  nodes_route_table_id      = flatten([module.vpc.nodes_rt])
  transit_gateway_id        = module.tgw.id
  tgw_vpc_stg_attachment_id = module.tgw-vpc-attachment.tgw_vpc_stg_attachment_id
  tgw_vpn_attachment_id     = module.s2svpn.tgw_vpn_attachment_id
}

module "eks" {
  source                        = "./cluster"
  vpc_id                        = module.vpc.vpc_id
  cluster-name                  = var.cluster-name
  instance-autoscaling-type     = var.instance-autoscaling-type
#  kubernetes-server-instance-sg = module.kubernetes-server.kubernetes-server-instance-sg
  apps_subnet                   = flatten([module.vpc.apps_subnet])
  nodes_subnet                  = flatten([module.vpc.nodes_subnet])
  subnet_ids                    = flatten([module.vpc.nodes_subnet, module.vpc.apps_subnet, module.vpc.public_subnet])
}

module "redis" {
  source                        = "./redis"
  cluster_id                    = var.redis-name
  engine                        = var.redis-engine
  node_type                     = var.redis-node-type
  parameter_group_name          = var.redis-parameter
  engine_version                = var.redis-engine-ver
  port                          = var.redis-port
  name_subnet_group             = var.redis-subnet-name
  subnet_ids                    = flatten([module.vpc.cache_subnet])
}

module "ecr" {
  source                        = "./ecr"
  ecr_name                      = flatten([var.ecr_name])
  image_tag                     = var.image_tag
}
