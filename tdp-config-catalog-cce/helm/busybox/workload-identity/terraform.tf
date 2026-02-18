

#######################################
# Agency
#######################################
resource "huaweicloud_identity_agency" "identity_agency" {
  name                  = "cce-workload-agency"
  description           = "Agencia para workloads en CCE"
  delegated_service_name = "op_svc_cce"

  enterprise_project_roles {
    enterprise_project = var.enterprise_project_name
    roles              = ["OBS Administrator", "CSMS FullAccess"]
  }
}

############################################
# Identity Provider (OIDC)
############################################

resource "huaweicloud_identity_provider" "cce_oidc" {
  name     = "cce-workload-oidc"
  protocol = "oidc"
  description = "Identity Provider for CCE"

  access_config {
    # Para Workload Identity debe ser program
    access_type = "program"

    # Issuer URL del cluster CCE Turbo
    provider_url = "https://oidc.cce.${var.region}.myhuaweicloud.com/id/${huaweicloud_cce_cluster.cce_cluster_turbo.id}"

    # Debe coincidir con el audience (aud) del token del ServiceAccount
    client_id = "huawei-cce"

    # JWKS obtenido con:
    # kubectl get --raw /openid/v1/jwks
    signing_key = jsonencode({
      "keys": [
        {
          "use": "sig",
          "kty": "RSA",
          "kid": "LH4pnQHcibGHMWNeTIRXAjWKRfKBJGk5UpEgLMpptfI",
          "alg": "RS256",
          "n": "w4L393mn8J7s0xW9gBYPUGVe-CrEWNBJonqM5JL-37TvZEAbQBEcJz7GbwthS8UaBiLbtc6SVq-ESAbFnCv4-EWmhAqZcyJyReG9Nd849cCTkfHag9yMKzw0xNbvUxlnKdk-72dg5S82yFboAGX8V5bBCcvBsfsTHSZP5-e7cmIU2JxECGaC4zkkcGQbx-rTVxsSsNT4EfrwI5AmAEcqA_M1A9Vvj_N65urZJ4NWK2YcpraRQWH8jpD4cj6nXUVPjbrRSz6-tUoJ9B5DKvdgv2tODWYekNPvZa_TLvgHVpSIL75PcqQ8FFOhZBluP2tJVu1XhHoqWAhNA-6_Zdrue3guppHjuTALF3W0xKmaCfsEX0E9rWnGp8yK2emmcQBCcfim6Ddqbdxijnbs5QOXsoP3RKfm6eeJoH6fdvSeSfnONP04qWVA0R3QJPMj-rmIYRPUmTfHnxqYnYKP7IZSUG5VKXNLs5Gp6uZKK8ffFYntdJIEnJzWbv-G5z5pcLdb",
          "e": "AQAB"
        }
      ]
    })
  }
}

resource "huaweicloud_identity_provider_mapping" "cce_workload_mapping" {
  provider_id = huaweicloud_identity_provider.cce_oidc.id

  mapping_rules = jsonencode([
    {
      remote = [
        {
          type = "sub"
          any_one_of = [
            "system:serviceaccount:default:sa-dew"
          ]
        }
      ]
      local = [
        {
          group = {
            name = huaweicloud_identity_agency.workload_agency.name
          }
        }
      ]
    },
    {
      remote = [
        {
          type = "sub"
          any_one_of = [
            "system:serviceaccount:default:sa-obs"
          ]
        }
      ]
      local = [
        {
          group = {
            name = huaweicloud_identity_agency.workload_agency.name
          }
        }
      ]
    }
  ])
}
