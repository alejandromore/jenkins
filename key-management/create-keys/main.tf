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
}

# Genera llave RSA
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Guarda la llave privada en Huawei Secret Manager
resource "huaweicloud_secrets_secret_v1" "private_key" {
  name          = "${var.project_name}-private-key"
  secret_binary = tls_private_key.ssh_key.private_key_pem
}

# Crea el KeyPair en Huawei Cloud
resource "huaweicloud_compute_keypair" "keypair" {
  name       = "${var.project_name}-keypair"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Output con el identificador del KeyPair
output "keypair_name" {
  description = "Nombre del KeyPair que se usará en futuros ECS"
  value       = huaweicloud_compute_keypair.keypair.name
}
