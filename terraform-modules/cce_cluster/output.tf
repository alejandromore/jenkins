output "cluster_id" {
  description = "ID del cluster CCE"
  value       = huaweicloud_cce_cluster.this.id
}

output "cluster_name" {
  description = "Nombre del cluster"
  value       = huaweicloud_cce_cluster.this.name
}
