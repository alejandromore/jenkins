output "rds_name" {
  value = var.rds_postgres_name
}

output "rds_private_ip" {
  value = module.rds_postgres.address[0]
}

output "rds_public_ip" {
  value = module.eip_rds_postgres.address
}
