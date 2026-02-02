# Información de la instancia APIG
output "apig_instance_id" {
  description = "ID de la instancia APIG"
  value       = huaweicloud_apig_instance.this.id
}

output "apig_instance_name" {
  description = "Nombre de la instancia APIG"
  value       = huaweicloud_apig_instance.this.name
}

output "apig_status" {
  description = "Estado de la instancia APIG"
  value       = huaweicloud_apig_instance.this.status
}

# Información del grupo de APIs
output "api_group_id" {
  description = "ID del grupo de APIs"
  value       = huaweicloud_apig_group.api_group.id
}

output "api_group_name" {
  description = "Nombre del grupo de APIs"
  value       = huaweicloud_apig_group.api_group.name
}

# Información del environment/stage
output "stage_id" {
  description = "ID del stage/environment"
  value       = huaweicloud_apig_environment.environment.id
}

output "stage_name" {
  description = "Nombre del stage/environment"
  value       = huaweicloud_apig_environment.environment.name
}
