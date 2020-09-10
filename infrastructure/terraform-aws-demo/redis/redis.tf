resource "aws_elasticache_subnet_group" "subnet_group" {
  provider = aws.staging
  name        = var.name_subnet_group
  # Uncomment below if u want using 3 subnet each other for 3 redis primary not replica
  # count       = length(var.subnet_ids)
  # subnet_ids  = element(var.subnet_ids, count.index)
  subnet_ids  = var.subnet_ids
}

# Uncomment below for using replica redis
resource "aws_elasticache_replication_group" "exercise-redis" {
  provider = aws.staging
  replication_group_id          = "exercise-staging-redis"
  replication_group_description = "exercise staging"
  node_type                     = var.node_type
  engine                        = var.engine
  engine_version                = var.engine_version
  port                          = var.port
  # parameter_group_name          = var.parameter_group_name
  subnet_group_name             = aws_elasticache_subnet_group.subnet_group.name
  automatic_failover_enabled    = true

  cluster_mode {
    replicas_per_node_group = 2
    num_node_groups         = 1
  }
}

# resource "aws_elasticache_parameter_group" "parameter" {
#   name   = "exercise-staging-cache-parameter"
#   family = "redis5.0"
# }

# resource "aws_elasticache_cluster" "redis-staging" {
#   count                = length(aws_elasticache_subnet_group.subnet_group.id)
#   cluster_id           = element(var.cluster_id, count.index)
#   engine               = var.engine
#   node_type            = var.node_type
#   num_cache_nodes      = 1
#   parameter_group_name = aws_elasticache_parameter_group.parameter.id
#   engine_version       = var.engine_version
#   port                 = var.port
#   subnet_group_name    = element(aws_elasticache_subnet_group.subnet_group.name, count.index)
# }