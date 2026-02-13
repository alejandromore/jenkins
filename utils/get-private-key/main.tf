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

provider "huaweicloud" {
  region     = "la-south-2"
}

variable "private_key_name" {
  type        = string
  description = "Nombre de la private key en CSMS"
  default     = "basic-project-private-key"
}

data "huaweicloud_csms_secret_version" "key_data" {
  secret_name = var.private_key_name
}

# Uso opcional: por ejemplo, para pasarla a otra herramienta de gestión
output "private_key_content" {
  value     = data.huaweicloud_csms_secret_version.key_data.secret_text
  sensitive = true
}