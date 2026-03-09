# Enterprise Project
data "huaweicloud_enterprise_project" "ep" {
  name = var.enterprise_project_name
}

############################################
# Identity Provider (OIDC)
############################################
resource "huaweicloud_identity_provider" "cce_oidc" {
  name        = "cce-workload-oidc"
  protocol    = "oidc"
  description = "OIDC provider for CCE workloads"
  sso_type    = "virtual_user_sso"

  access_config {
    access_type = "program"

    provider_url = "https://kubernetes.default.svc.cluster.local"

    client_id   = var.client_id
    signing_key = var.oidc_jwks
  }
}

############################################
# Identity Group and Role Assignments
############################################
# Groups: group_name_obs and group_name_dew
resource "huaweicloud_identity_group" "obs_group" {
  name        = var.group_name_obs
  description = "IAM group for CCE Workload Identity - OBS"
}

# Crear rol con permisos de lectura a OBS
resource "huaweicloud_identity_role" "obs_read_policy" {
  name        = "obs-read-policy"
  description = "Allow list and download access to all OBS buckets"
  type        = "XA"

  policy = jsonencode({
    Version = "1.1"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "obs:bucket:ListAllMybuckets",
          "obs:bucket:HeadBucket",
          "obs:bucket:ListBucket",
          "obs:bucket:GetBucketLocation",
          "obs:object:GetObject"
        ]
        Resource = ["*"]
      }
    ]
  })
}

resource "huaweicloud_identity_group_role_assignment" "obs_group_assignment" {
  depends_on = [time_sleep.wait_iam]

  group_id = huaweicloud_identity_group.obs_group.id
  role_id  = huaweicloud_identity_role.obs_read_policy.id
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

resource "huaweicloud_identity_group" "dew_group" {
  name        = var.group_name_dew
  description = "IAM group for CCE Workload Identity - Dew"
}

# Crear rol con permisos de lectura a CSMS (KMS)
resource "huaweicloud_identity_role" "dew_read_policy" {
  name        = "dew-read-policy"
  description = "Allow read access to CSMS secrets for CCE"
  type        = "XA"

  policy = jsonencode({
    Version = "1.1"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "csms:secret:list",
          "csms:secret:get",
          "csms:secretVersion:list",
          "csms:secretVersion:get"
        ]
        Resource = ["*"]
      }
    ]
  })
}

resource "huaweicloud_identity_group_role_assignment" "dew_group_assignment" {
  depends_on = [time_sleep.wait_iam]

  group_id = huaweicloud_identity_group.dew_group.id
  role_id  = huaweicloud_identity_role.dew_read_policy.id
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

resource "time_sleep" "wait_iam" {

  depends_on = [
    huaweicloud_identity_group.obs_group,
    huaweicloud_identity_group.dew_group,
    huaweicloud_identity_role.obs_read_policy,
    huaweicloud_identity_role.dew_read_policy
  ]

  create_duration = "60s"
}

############################################
# Identity Provider Mapping
############################################
resource "huaweicloud_identity_provider_mapping" "workload_mapping" {
  provider_id = huaweicloud_identity_provider.cce_oidc.id

  mapping_rules = jsonencode([
    {
      local = [
        {
          user: {
            name = "cce-workload-user"
          }
        },
        {
          group = {
            name = huaweicloud_identity_group.obs_group.name
          }
        }
      ]
      remote = [
        {
          type = "sub"
          any_one_of = [
            "system:serviceaccount:${var.namespace}:${var.obs_service_account_name}"
          ]
        }
      ]
    },
    {
      local = [
        {
          user: {
            name = "cce-workload-user"
          }
        },
        {
          group = {
            name = huaweicloud_identity_group.dew_group.name
          }
        }
      ]
      remote = [
        {
          type = "sub"
          any_one_of = [
            "system:serviceaccount:${var.namespace}:${var.dew_service_account_name}"
          ]
        }
      ]
    }
  ])
}

#######################################
# DEW - Secret
#######################################

locals {
  secrets_file = yamldecode(file("${path.module}/secrets/secrets-dec.yaml"))
  dew_secret_payload = merge( 
    local.secrets_file.stringData,
    {
      URL      = "wwww.google.com"
      USUARIO  = "alejandro"
      PASSWORD = "P@ssw0rdSecure123!"
      PORT     = "5432"
    }
  )
}

module "dew_secret" {
  source = "../../../terraform-modules/dew"

  secret_name           = var.dew_secret_name
  secret_description    = var.dew_secret_description
  secret_payload        = local.dew_secret_payload

  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}
