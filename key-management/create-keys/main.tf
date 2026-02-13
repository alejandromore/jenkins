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

# 1. Generar la llave en memoria (RSA 4096)
resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Registrar la llave pública en KPS (Key Pair Service)
# Documentación: https://registry.terraform.io
resource "huaweicloud_kps_keypair" "ecs_key" {
  name       = "${var.project_name}-key"
  public_key = tls_private_key.rsa_key.public_key_openssh
}

# 3. Guardar la llave privada en CSMS (Cloud Secret Management Service)
# Usamos 'secret_text' para inyectar el contenido directamente
# Documentación: https://registry.terraform.io
resource "huaweicloud_csms_secret" "ecs_key_storage" {
  name        = "${var.project_name}-private-key"
  description = "Llave privada para el proyecto ${var.project_name}"
  secret_text = tls_private_key.rsa_key.private_key_pem
}

# Output para el nombre de la llave (usar en el ECS)
output "key_pair_name" {
  value = huaweicloud_kps_keypair.ecs_key.name
}
