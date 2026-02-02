output "ecs_id" {
  description = "ID of the ECS instance"
  value       = huaweicloud_compute_instance.ecs.id
}

output "ecs_name" {
  description = "Name of the ECS instance"
  value       = huaweicloud_compute_instance.ecs.name
}

output "ecs_private_ip" {
  description = "Private IP of the ECS"
  value       = huaweicloud_compute_instance.ecs.access_ip_v4
}

output "ecs_system_disk_size" {
  description = "Tamaño del disco del sistema en GB"
  value       = huaweicloud_compute_instance.ecs.system_disk_size
}

output "ecs_system_disk_type" {
  description = "Tipo del disco del sistema (SAS, SATA, SSD)"
  value       = huaweicloud_compute_instance.ecs.system_disk_type
}

output "ecs_system_disk_id" {
  description = "ID del volumen del disco del sistema"
  value       = huaweicloud_compute_instance.ecs.system_disk_id
}