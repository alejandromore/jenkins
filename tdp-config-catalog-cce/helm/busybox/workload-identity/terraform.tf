#######################################
# Agency
#######################################
# 1. El data source correcto es 'identity_user' (v1.86.0 no tiene identity_account)
data "huaweicloud_identity_user" "current" {}

# 2. Corregir Agency (Se usa delegated_domain_name en lugar de delegation_domain)
resource "huaweicloud_identity_agency" "obs_workload_agency" {
  name                  = "cce-workload-agency"
  description           = "Agencia para workloads en CCE"

  delegated_domain_name = "hwstaff_intl_a00392472"

  enterprise_project_roles {
    enterprise_project = var.enterprise_project_name
    roles              = ["OBS Administrator", "CSMS FullAccess"]
  }
}

#######################################
# Identity Provider (OIDC)
#######################################
# 3. Identity Provider (OIDC) - Mapeo ahora es un atributo JSON interno
resource "huaweicloud_identity_provider" "cce_oidc" {
  name        = "cce-config-catalog-idp"
  protocol    = "oidc"
  access_type = "program" # Requerido

  access_config {
    # Cambios de nombres de atributos según la v1.86.0
    provider_url = huaweicloud_cce_cluster.cce_cluster_turbo.iam_url
    client_id    = "sts.myhuaweicloud.com"
    signing_key  = huaweicloud_cce_cluster.cce_cluster_turbo.oidc_config[0].issuer_key
  }

  # El mapping ya no es un recurso independiente, es un bloque JSON
  mapping = jsonencode([
    {
      "local": [{ "agency": huaweicloud_identity_agency.obs_workload_agency.name }],
      "remote": [
        {
          "type": "sub",
          "any_one_of": [
            "system:serviceaccount:default:sa-obs",
            "system:serviceaccount:default:sa-dew"
          ]
        }
      ]
    }
  ])
}