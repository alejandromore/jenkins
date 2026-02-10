output "ecs_public_name" {
  value = var.ecs_public_name
}

output "ecs_public_ip" {
  value = module.eip_ecs_publico.address
}

output "rds_name" {
  value = var.rds_postgres_name
}

output "rds_private_ip" {
  value = module.rds_postgres.address[0]
}

output "rds_public_ip" {
  value = module.eip_rds_postgres.address
}

output "rds_postgres_password" {
  value = var.rds_postgres_password
}

output "ecs_pem_path" {
  value = "${path.module}/keys/id_rsa_ecs.pem"
}
