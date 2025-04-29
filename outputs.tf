// Cluster outputs
output "cluster_id" {
  value       = google_alloydb_cluster.default.cluster_id
  description = "The ID of the AlloyDB cluster"
}

output "cluster_name" {
  value       = google_alloydb_cluster.default.name
  description = "The name of the AlloyDB cluster"
}

output "cluster_self_link" {
  value       = google_alloydb_cluster.default.id
  description = "The URI of the AlloyDB cluster"
}

// Primary instance outputs
output "primary_instance_id" {
  value       = google_alloydb_instance.primary.instance_id
  description = "The ID of the primary instance"
}

output "primary_instance_name" {
  value       = google_alloydb_instance.primary.name
  description = "The name of the primary instance"
}

output "primary_instance_self_link" {
  value       = google_alloydb_instance.primary.id
  description = "The URI of the primary instance"
}

output "primary_instance_ip_address" {
  value       = google_alloydb_instance.primary.ip_address
  description = "The IP address of the primary instance"
}

// Read replica outputs
output "read_replica_instance_names" {
  value       = [for r in google_alloydb_instance.read_replicas : r.name]
  description = "The instance names for the read replica instances"
}

output "read_replica_instance_ids" {
  value       = [for r in google_alloydb_instance.read_replicas : r.instance_id]
  description = "The instance IDs for the read replica instances"
}

output "read_replica_instance_ip_addresses" {
  value       = [for r in google_alloydb_instance.read_replicas : r.ip_address]
  description = "The IP addresses of the read replica instances"
}

output "read_replica_instance_self_links" {
  value       = [for r in google_alloydb_instance.read_replicas : r.id]
  description = "The URIs of the read replica instances"
}

// User outputs
output "generated_user_password" {
  description = "The auto generated default user password if no input password was provided"
  value       = random_id.user_password.hex
  sensitive   = true
}

// Resource outputs
output "primary" {
  value       = google_alloydb_instance.primary
  description = "The `google_alloydb_instance` resource representing the primary instance"
}

output "read_replicas" {
  value       = values(google_alloydb_instance.read_replicas)
  description = "A list of `google_alloydb_instance` resources representing the read replicas"
}

output "instances" {
  value       = concat([google_alloydb_instance.primary], values(google_alloydb_instance.read_replicas))
  description = "A list of all `google_alloydb_instance` resources we've created"
}

output "cluster" {
  value       = google_alloydb_cluster.default
  description = "The `google_alloydb_cluster` resource"
}

output "backup" {
  value       = var.backup_configuration.enabled ? google_alloydb_backup.scheduled_backups[0] : null
  description = "The `google_alloydb_backup` resource if backup is enabled"
}
