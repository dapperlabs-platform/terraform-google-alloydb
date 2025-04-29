# terraform-google-alloydb

This module manages Google Cloud AlloyDB resources.

Note: CloudSQL provides [disk autoresize](https://cloud.google.com/sql/docs/mysql/instance-settings#automatic-storage-increase-2ndgen) feature which can cause a [Terraform configuration drift](https://www.hashicorp.com/blog/detecting-and-managing-drift-with-terraform) due to the value in `disk_size` variable, and hence any updates to this variable is ignored in the [Terraform lifecycle](https://www.terraform.io/docs/configuration/resources.html#ignore_changes).

<!-- BEGIN_TF_DOCS -->
Copyright 2023 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_alloydb_cluster.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_cluster) | resource |
| [google_alloydb_instance.primary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_instance) | resource |
| [google_alloydb_instance.read_replicas](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_instance) | resource |
| [google_alloydb_backup.scheduled_backups](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_backup) | resource |
| [google_alloydb_user.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_user) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_id.user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_databases"></a> [additional\_databases](#input\_additional\_databases) | A list of databases to be created in your cluster | <pre>list(object({<br>    name      = string<br>    charset   = string<br>    collation = string<br>  }))</pre> | `[]` | no |
| <a name="input_additional_users"></a> [additional\_users](#input\_additional\_users) | A list of users to be created in your cluster | <pre>list(object({<br>    name     = string<br>    password = string<br>  }))</pre> | `[]` | no |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | The availability type for the master instance.This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`. | `string` | `"ZONAL"` | no |
| <a name="input_backup_configuration"></a> [backup\_configuration](#input\_backup\_configuration) | The backup\_configuration settings subblock for the database setings | <pre>object({<br>    enabled                        = bool<br>    start_time                     = string<br>    location                       = string<br>    point_in_time_recovery_enabled = bool<br>    transaction_log_retention_days = string<br>    retained_backups               = number<br>    retention_unit                 = string<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "location": null,<br>  "point_in_time_recovery_enabled": false,<br>  "retained_backups": null,<br>  "retention_unit": null,<br>  "start_time": null,<br>  "transaction_log_retention_days": null<br>}</pre> | no |
| <a name="input_cpu_count"></a> [cpu\_count](#input\_cpu\_count) | The number of CPUs for the primary instance | `number` | `2` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags) | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the default database to create | `string` | `"default"` | no |
| <a name="input_enable_default_user"></a> [enable\_default\_user](#input\_enable\_default\_user) | Enable or disable the creation of the default user | `bool` | `true` | no |
| <a name="input_encryption_key_name"></a> [encryption\_key\_name](#input\_encryption\_key\_name) | The full path to the encryption key used for the CMEK disk encryption | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the AlloyDB cluster | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | The VPC network to use for the AlloyDB cluster | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to manage the AlloyDB resources | `string` | n/a | yes |
| <a name="input_random_instance_name"></a> [random\_instance\_name](#input\_random\_instance\_name) | Sets random suffix at the end of the AlloyDB resource name | `bool` | `false` | no |
| <a name="input_read_replica_name_suffix"></a> [read\_replica\_name\_suffix](#input\_read\_replica\_name\_suffix) | The optional suffix to add to the read instance name | `string` | `""` | no |
| <a name="input_read_replicas"></a> [read\_replicas](#input\_read\_replicas) | List of read replicas to create | `list(any)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | The region of the AlloyDB resources | `string` | `"us-central1"` | no |
| <a name="input_user_labels"></a> [user\_labels](#input\_user\_labels) | The key/value labels for the master instances. | `map(string)` | `{}` | no |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | The name of the default user | `string` | `"default"` | no |
| <a name="input_user_password"></a> [user\_password](#input\_user\_password) | The password for the default user. If not set, a random one will be generated. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup"></a> [backup](#output\_backup) | The `google_alloydb_backup` resource if backup is enabled |
| <a name="output_cluster"></a> [cluster](#output\_cluster) | The `google_alloydb_cluster` resource |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the AlloyDB cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the AlloyDB cluster |
| <a name="output_cluster_self_link"></a> [cluster\_self\_link](#output\_cluster\_self\_link) | The URI of the AlloyDB cluster |
| <a name="output_generated_user_password"></a> [generated\_user\_password](#output\_generated\_user\_password) | The auto generated default user password if no input password was provided |
| <a name="output_instances"></a> [instances](#output\_instances) | A list of all `google_alloydb_instance` resources we've created |
| <a name="output_primary"></a> [primary](#output\_primary) | The `google_alloydb_instance` resource representing the primary instance |
| <a name="output_primary_instance_id"></a> [primary\_instance\_id](#output\_primary\_instance\_id) | The ID of the primary instance |
| <a name="output_primary_instance_ip_address"></a> [primary\_instance\_ip\_address](#output\_primary\_instance\_ip\_address) | The IP address of the primary instance |
| <a name="output_primary_instance_name"></a> [primary\_instance\_name](#output\_primary\_instance\_name) | The name of the primary instance |
| <a name="output_primary_instance_self_link"></a> [primary\_instance\_self\_link](#output\_primary\_instance\_self\_link) | The URI of the primary instance |
| <a name="output_read_replica_instance_ids"></a> [read\_replica\_instance\_ids](#output\_read\_replica\_instance\_ids) | The instance IDs for the read replica instances |
| <a name="output_read_replica_instance_ip_addresses"></a> [read\_replica\_instance\_ip\_addresses](#output\_read\_replica\_instance\_ip\_addresses) | The IP addresses of the read replica instances |
| <a name="output_read_replica_instance_names"></a> [read\_replica\_instance\_names](#output\_read\_replica\_instance\_names) | The instance names for the read replica instances |
| <a name="output_read_replica_instance_self_links"></a> [read\_replica\_instance\_self\_links](#output\_read\_replica\_instance\_self\_links) | The URIs of the read replica instances |
| <a name="output_read_replicas"></a> [read\_replicas](#output\_read\_replicas) | A list of `google_alloydb_instance` resources representing the read replicas |
<!-- END_TF_DOCS -->