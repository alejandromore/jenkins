terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">= 1.81.0"
    }
  }
}

provider "huaweicloud" {
  region     = var.region
  #Credenciales de las variables de entorno
}