output "cluster_id" {
  description = "ID del cluster CCE"
  value       = huaweicloud_cce_cluster.this.id
}

output "cluster_name" {
  description = "Nombre del cluster"
  value       = huaweicloud_cce_cluster.this.name
}

output "kubeconfig" {
  description = "Kubeconfig content for the CCE cluster"
  value       = huaweicloud_cce_cluster.this.kube_config.0.content
  sensitive   = true
}