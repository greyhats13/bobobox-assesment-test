output "aws_nodes_rt_route_tgw_id" {
  value = [aws_route.nodes_rt_route_tgw_network_stg.*.id]
}
