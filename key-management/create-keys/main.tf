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
resource "huaweicloud_kps_keypair" "ecs_key" {
  name       = "${var.project_name}-key"
  public_key = tls_private_key.rsa_key.public_key_openssh
}

# 3. Crear el "Contenedor" del secreto en CSMS
resource "huaweicloud_csms_secret" "ecs_key_container" {
  name        = "${var.project_name}-private-key"
  description = "Contenedor para la llave privada de ${var.project_name}"
}

# 4. Crear la "Versión" del secreto (aquí es donde vive el contenido)
resource "huaweicloud_csms_secret_version" "ecs_key_value" {
  secret_id   = huaweicloud_csms_secret.ecs_key_container.id
  secret_data = tls_private_key.rsa_key.private_key_pem
}

# Output para tu ECS
output "key_pair_name" {
  value = huaweicloud_kps_keypair.ecs_key.name
}
