output "database-ip" {
  value = google_sql_database_instance.main.ip_address.0.ip_address
}

output "redis-ip" {
  value = google_redis_instance.cache.host
}