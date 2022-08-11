output "postgres-address" {
  value       = aws_db_instance.multi-docker-postgres.address
  description = "Connect to the Postgres database at this endpoint"
}

output "postgres-port" {
  value       = aws_db_instance.multi-docker-postgres.port
  description = "The port the postgres database is listening on"
}

output "redis-cluster-address" {
  value       = aws_elasticache_cluster.multi-docker-redis.cache_nodes.0.address
  description = "Connect to Redis at this endpoint"
}

output "redis-cluster-port" {
  value       = aws_elasticache_cluster.multi-docker-redis.port
  description = "The port the Redis database is listening on"
}

output "vpc-security-group" {
  value       = aws_security_group.multi-docker.id
  description = "VPC security group created"
}
