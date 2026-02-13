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

# 1. Generamos la llave en memoria (no toca disco)
resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Registramos la llave pública en KPS para que el ECS la reconozca
resource "huaweicloud_kps_keypair" "ecs_key" {
  name       = "${var.project_name}-key"
  public_key = tls_private_key.rsa_key.public_key_openssh
}

# 3. Guardamos la llave privada en CSMS (Cloud Secret Management Service)
resource "huaweicloud_csms_secret" "ecs_private_key_secret" {
  name        = "${var.project_name}-private-key"
  description = "Llave privada para el proyecto ${var.project_name}"
  
  # Guardamos el contenido de la llave privada como el valor del secreto
  secret_data = tls_private_key.rsa_key.private_key_pem
}

# Output: Solo el nombre del keypair (necesario para el ECS)
output "key_pair_name" {
  value = huaweicloud_kps_keypair.ecs_key.name
}
