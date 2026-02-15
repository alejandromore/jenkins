resource "huaweicloud_identity_agency" "obs_workload_agency" {
  name        = "obs-workload-agency"
  description = "Agency for CCE OIDC Workload Identity"

  project_role {
    project = var.region
    roles = [
      "OBS OperateAccess"
    ]
  }
}

resource "huaweicloud_identity_provider" "cce_oidc" {
  name     = "cce-oidc-provider"
  protocol = "oidc"

  oidc {
    issuer_url = "https://oidc.cce.la-south-2.myhuaweicloud.com/${module.cce_cluster.cluster_id}"
    client_id  = "sts.amazonaws.com" # requerido aunque no sea AWS
  }
}

resource "huaweicloud_identity_agency_trust_policy" "cce_trust" {
  agency_id = huaweicloud_identity_agency.obs_workload_agency.id

  policy = jsonencode({
    Version = "1.0"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = huaweicloud_identity_provider.cce_oidc.id
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "oidc:sub" = "system:serviceaccount:default:obs-dew-sa"
          }
        }
      }
    ]
  })
}

