output "ecs_name" {
  value = var.ecs_public_name
}

output "ecs_public_ip" {
  value = module.eip_ecs_publico.address
}

data "huaweicloud_csms_secret_version" "key_data" {
  secret_name = var.private_key_name
}

# Uso opcional: por ejemplo, para pasarla a otra herramienta de gestión
output "private_key_content" {
  value     = data.huaweicloud_csms_secret_version.key_data.secret_text
  sensitive = true
}