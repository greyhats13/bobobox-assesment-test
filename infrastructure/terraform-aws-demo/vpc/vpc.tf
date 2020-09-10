//Provider untuk akun staging
provider "aws" {
  alias                   = "staging"
  region                  = var.region
  profile                 = var.profile_staging
  shared_credentials_file = var.aws_credentials
}

data "aws_availability_zones" "available" {
  provider = aws.staging
}

# VPC
resource "aws_vpc" "vpc_stg" {
  provider   = aws.staging
  cidr_block = var.cidr

  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "apps_cidr" {
  provider = aws.staging
  vpc_id   = aws_vpc.vpc_stg.id
  # for apps
  cidr_block = "10.1.0.0/20"
}

resource "aws_vpc_ipv4_cidr_block_association" "nodes_cidr" {
  provider = aws.staging
  vpc_id   = aws_vpc.vpc_stg.id
  # for public, nodes and private
  cidr_block = "10.43.192.128/25"
}

resource "aws_vpc_ipv4_cidr_block_association" "cache_cidr" {
  provider   = aws.staging
  vpc_id     = aws_vpc.vpc_stg.id
  cidr_block = "10.10.0.0/25"
}

#Subnets
#Public Subnet
resource "aws_subnet" "public_subnet" {
  provider          = aws.staging
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc_ipv4_cidr_block_association.nodes_cidr.vpc_id
  cidr_block        = element(var.public_subnet_cidr, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Name                                        = "exercise-public-subnet-${element(data.aws_availability_zones.available.names, count.index)}-stg-TF"
  }
}

#Cache Subnet
resource "aws_subnet" "cache_subnet" {
  provider          = aws.staging
  count             = length(var.cache_subnet_cidr)
  vpc_id            = aws_vpc_ipv4_cidr_block_association.cache_cidr.vpc_id
  cidr_block        = element(var.cache_subnet_cidr, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Name                                        = "exercise-cache-subnet-${element(data.aws_availability_zones.available.names, count.index)}-stg-TF"
  }
}

#EKS Kubernetes Subnet
resource "aws_subnet" "nodes_subnet" {
  provider          = aws.staging
  count             = length(var.nodes_subnet_cidr)
  vpc_id            = aws_vpc_ipv4_cidr_block_association.nodes_cidr.vpc_id
  cidr_block        = element(var.nodes_subnet_cidr, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Name                                        = "exercise-nodes-subnet-${element(data.aws_availability_zones.available.names, count.index)}-stg-TF"
  }
}

#apps worker
resource "aws_subnet" "apps_subnet" {
  provider          = aws.staging
  count             = length(var.apps_subnet_cidr)
  vpc_id            = aws_vpc_ipv4_cidr_block_association.apps_cidr.vpc_id
  cidr_block        = element(var.apps_subnet_cidr, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Name                                        = "exercise-apps-subnet-${element(data.aws_availability_zones.available.names, count.index)}-stg-TF"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  provider = aws.staging
  vpc_id   = aws_vpc.vpc_stg.id

  tags = {
    Name = "IGW STG TF"
  }
}

resource "aws_eip" "eip" {
  provider = aws.staging
  count    = 3
  vpc      = true

  tags = {
    Name = "Elastic IP NAT STG TF"
  }
}

# Nat Gateway allocated to elastic ip's
resource "aws_nat_gateway" "nat-gw" {
  provider      = aws.staging
  count         = length(aws_subnet.public_subnet)
  allocation_id = element(aws_eip.eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)

  tags = {
    Name = "NAT-STG-${element(data.aws_availability_zones.available.names, count.index)}-TF"
  }
}

#Public Route Table
resource "aws_route_table" "public-rt" {
  provider = aws.staging
  vpc_id   = aws_vpc.vpc_stg.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Name                                        = "Public RT STG TF"
  }
}

#Nodes Route Table
resource "aws_route_table" "node-rt" {
  provider = aws.staging
  count    = length(var.nodes_subnet_cidr)
  vpc_id   = aws_vpc.vpc_stg.id
  #Routing to NAT
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat-gw.*.id, count.index)
  }

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Name                                        = "Nodes-RT-${element(data.aws_availability_zones.available.names, count.index)}-TF"
  }
}

resource "aws_route_table" "apps-rt" {
  provider = aws.staging
  count    = length(var.apps_subnet_cidr)
  vpc_id   = aws_vpc.vpc_stg.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat-gw.*.id, count.index)
  }

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Name                                        = "Apps-RT-${element(data.aws_availability_zones.available.names, count.index)}-TF"
  }
}

resource "aws_route_table_association" "public_route_assoc" {
  provider       = aws.staging
  count          = length(aws_subnet.public_subnet)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "node_route_assoc" {
  provider       = aws.staging
  count          = length(aws_subnet.nodes_subnet)
  subnet_id      = element(aws_subnet.nodes_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.node-rt.*.id, count.index)
}

resource "aws_route_table_association" "apps_route_assoc" {
  provider       = aws.staging
  count          = length(aws_subnet.apps_subnet)
  subnet_id      = element(aws_subnet.apps_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.apps-rt.*.id, count.index)
}
