output "redis_id" {
  value = aws_elasticache_replication_group.exercise-redis.id
}

output "redis_primary_ip" {
  value = aws_elasticache_replication_group.exercise-redis.primary_endpoint_address
}

output "redis_config_endpoint" {
  value = aws_elasticache_replication_group.exercise-redis.configuration_endpoint_address
}