#######################################
# Agency
#######################################
data "huaweicloud_identity_account" "current" {

}

resource "huaweicloud_identity_agency" "obs_workload_agency" {
  name = "ecs-obs-dew-agency"
  description = "Agencia para workloads en CCE"
  
  delegation_domain {
    id = data.huaweicloud_identity_account.current.id 
  }

  enterprise_project_roles {
    enterprise_project = var.enterprise_project_name
    roles = ["OBS Administrator", "CSMS FullAccess"]
  }
}


#######################################
# Identity Provider (OIDC)
#######################################

# Crear el Identity Provider para el Clúster CCE
resource "huaweicloud_identity_provider" "cce_oidc" {
  name     = "cce-config-catalog-idp"
  protocol = "oidc"

  access_config {
    idp_url   = data.huaweicloud_cce_cluster.cce_cluster_turbo.iam_url
    client_id = "sts.myhuaweicloud.com"
  }
}

# Configuración de Reglas de Conversión
resource "huaweicloud_identity_mapping" "cce_sa_mapping" {
  identity_provider_id = huaweicloud_identity_provider.cce_oidc.id

  # Regla para el SA de OBS
  rules {
    local {
      agency = huaweicloud_identity_agency.obs_workload_agency.name
    }
    remote {
      attribute = "sub"
      condition = "anyOf"
      value     = ["system:serviceaccount:default:sa-obs"]  #default es el namespace
    }
  }

  # Regla para el SA de DEW
  rules {
    local {
      agency = huaweicloud_identity_agency.obs_workload_agency.name
    }
    remote {
      attribute = "sub"
      condition = "anyOf"
      value     = ["system:serviceaccount:default:sa-dew"]  #default es el namespace
    }
  }
}