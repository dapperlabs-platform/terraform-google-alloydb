resource "random_id" "suffix" {
  count       = var.random_instance_name ? 1 : 0
  byte_length = 4
}

locals {
  cluster_name = var.random_instance_name ? "${var.name}-${random_id.suffix[0].hex}" : var.name
  databases    = { for db in var.additional_databases : db.name => db }
  users        = { for u in var.additional_users : u.name => u }
}

resource "random_id" "user_password" {
  byte_length = 8
}

resource "google_alloydb_cluster" "default" {
  cluster_id = local.cluster_name
  location   = var.region
  project    = var.project_id
  
  network_config {
    network = var.network
  }

  initial_user {
    user     = var.user_name
    password = var.user_password == "" ? random_id.user_password.hex : var.user_password
  }

  labels = var.user_labels

  dynamic "backup_config" {
    for_each = var.backup_configuration.enabled ? [var.backup_configuration] : []
    content {
      enabled                        = backup_config.value.enabled
      location                       = backup_config.value.location
      point_in_time_recovery_enabled = backup_config.value.point_in_time_recovery_enabled
      
      backup_retention_settings {
        retained_backups = backup_config.value.retained_backups
        retention_unit   = backup_config.value.retention_unit
      }
    }
  }

  encryption_config {
    kms_key_name = var.encryption_key_name
  }
}

resource "google_alloydb_instance" "primary" {
  cluster       = google_alloydb_cluster.default.name
  instance_id   = "${local.cluster_name}-primary"
  instance_type = "PRIMARY"
  
  machine_config {
    cpu_count = var.cpu_count
  }

  availability_type = var.availability_type
  
  database_flags = {
    for flag in var.database_flags : flag.name => flag.value
  }

  labels = var.user_labels

  depends_on = [google_alloydb_cluster.default]
}

resource "google_alloydb_instance" "read_replicas" {
  for_each = {
    for idx, replica in var.read_replicas : 
    "${local.cluster_name}-replica-${idx}${var.read_replica_name_suffix}" => replica
  }
  
  cluster       = google_alloydb_cluster.default.name
  instance_id   = each.key
  instance_type = "READ_POOL"
  
  machine_config {
    cpu_count = lookup(each.value, "cpu_count", var.cpu_count)
  }

  read_pool_config {
    node_count = lookup(each.value, "node_count", 1)
  }

  database_flags = {
    for flag in lookup(each.value, "database_flags", var.database_flags) : flag.name => flag.value
  }

  labels = lookup(each.value, "user_labels", var.user_labels)

  depends_on = [google_alloydb_instance.primary]
}

resource "google_alloydb_user" "default" {
  user_type = "CLOUD_IAM_USER"
  count      = var.enable_default_user ? 0 : 1 # Skip if already created via initial_user
  cluster    = google_alloydb_cluster.default.name
  user_id    = var.user_name
  password   = var.user_password == "" ? random_id.user_password.hex : var.user_password
  
  depends_on = [google_alloydb_instance.primary]
}

resource "google_alloydb_backup" "scheduled_backups" {
  count         = var.backup_configuration.enabled ? 1 : 0
  location      = var.region
  backup_id     = "${local.cluster_name}-backup"
  cluster_name  = google_alloydb_cluster.default.name
  project       = var.project_id
  
  description   = "Scheduled backup for ${local.cluster_name}"
  
  depends_on    = [google_alloydb_instance.primary]
}