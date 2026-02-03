output "dws_cluster_id" {
  value       = huaweicloud_dws_cluster.this.id
  description = "ID of the created DWS cluster"
}

output "dws_cluster_name" {
  value       = huaweicloud_dws_cluster.this.name
  description = "Name of the DWS cluster"
}

output "dws_endpoints" {
  value       = huaweicloud_dws_cluster.this.endpoints
  description = "Endpoints of the DWS cluster"
}

output "dws_status" {
  value       = huaweicloud_dws_cluster.this.status
  description = "Current status of the DWS cluster"
}