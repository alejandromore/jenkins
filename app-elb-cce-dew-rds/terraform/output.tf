output "cce_name" {
  value = var.cce_cluster_name
}

output "cce_public_ip" {
  value = module.eip_cce_cluster.address
}

output "cluster_id" {
  value = module.cce_cluster.cluster_id
}

output "rds_public_ip" {
  value = module.eip_rds_postgres.address
}
