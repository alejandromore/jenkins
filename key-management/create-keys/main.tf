terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">= 1.46.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
}

variable "project_name" {
  type        = string
  description = "Nombre del proyecto"
  default     = "basic-project"
}

# 1. Crear el Key Pair
resource "huaweicloud_kps_keypair" "ecs_key" {
  name = "${var.project_name}-keypair"
  # La llave se crea y se registra en el servicio KPS.
  save_private_key = true 
}

# 2. Output del Nombre (Lo que usará el ECS)
output "key_pair_name" {
  value       = huaweicloud_kps_keypair.ecs_key.name
  description = "Este es el nombre que debes pasar al recurso huaweicloud_compute_instance"
}