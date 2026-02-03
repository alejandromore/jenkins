output "cce_name" {
  value = var.cce_cluster_name
}

output "cce_public_ip" {
  value = module.eip_cce_cluster.address
}
