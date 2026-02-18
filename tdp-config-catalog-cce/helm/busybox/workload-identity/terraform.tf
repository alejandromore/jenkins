#######################################
# Agency
#######################################
# Obtiene la información de la cuenta autenticada actualmente
data "huaweicloud_identity_account" "current" {}

# El ID se accede mediante la propiedad .id
output "account_id" {
  value = data.huaweicloud_identity_account.current.id
}

# Agency Única: Permisos para OBS y DEW (CSMS)
resource "huaweicloud_identity_agency" "workload_agency" {
  name        = "cce-workload-agency" # Asegura que coincida con el YAML
  description = "Agencia para workloads OBS y DEW en CCE"
  
  delegation_domain {
    id = data.huaweicloud_identity_account.current.id 
  }

  # Usamos roles de alcance global o EP según tu necesidad
  enterprise_project_roles {
    enterprise_project = var.enterprise_project_name
    roles              = ["OBS Administrator", "CSMS FullAccess"]
  }
}

#######################################
# Identity Provider (OIDC)
#######################################
# Identity Provider (OIDC)
resource "huaweicloud_identity_provider" "cce_oidc" {
  name     = "cce-oidp"
  protocol = "oidc"

  access_config {
    # El IAM URL se obtiene del cluster CCE
    idp_url   = data.huaweicloud_cce_cluster.cce_cluster_turbo.iam_url
    client_id = "sts.myhuaweicloud.com"
  }
}

# Reglas de Mapeo: Conecta SAs específicos con la Agency
resource "huaweicloud_identity_mapping" "cce_sa_mapping" {
  identity_provider_id = huaweicloud_identity_provider.cce_oidc.id

  # Regla unificada para ambos ServiceAccounts
  rules {
    local {
      agency = huaweicloud_identity_agency.workload_agency.name
    }
    remote {
      attribute = "sub"
      condition = "anyOf"
      value     = [
        "system:serviceaccount:default:sa-obs",
        "system:serviceaccount:default:sa-dew"
      ]
    }
  }
}