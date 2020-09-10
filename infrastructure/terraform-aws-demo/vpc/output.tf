output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc_stg.id
}

output "elastic_ip" {
  value = [aws_eip.eip.*.id]
}

output "vpc_id_secondary" {
  description = "Secondary ID of the VPC"
  value       = aws_vpc_ipv4_cidr_block_association.apps_cidr.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc_stg.cidr_block
}

output "vpc_apps_cidr_block" {
  value = aws_vpc_ipv4_cidr_block_association.apps_cidr.cidr_block
}

output "vpc_nodes_cidr_block" {
  value = aws_vpc_ipv4_cidr_block_association.nodes_cidr.cidr_block
}

output "vpc_cache_cidr_block" {
  value = aws_vpc_ipv4_cidr_block_association.cache_cidr.cidr_block
}

output "nodes_subnet" {
  value = [aws_subnet.nodes_subnet.*.id]
}

output "public_subnet" {
  value = aws_subnet.public_subnet.*.id
}

output "cache_subnet" {
  value = [aws_subnet.cache_subnet.*.id]
}

output "apps_subnet" {
  value = [aws_subnet.apps_subnet.*.id]
}

output "nodes_rt" {
  value = [aws_route_table.node-rt.*.id]
}

