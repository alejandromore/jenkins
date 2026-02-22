#######################################
# Crear IAM User
#######################################
resource "huaweicloud_identity_user" "cce_programmatic_user" {
  name        = "cce-programmatic-user"
  description = "IAM user for legacy pattern from CCE"
  enabled     = true
}

resource "huaweicloud_identity_access_key" "cce_user_key" {
  user_id = huaweicloud_identity_user.cce_programmatic_user.id
}

#######################################
# Asignar privilegios al IAM User
#######################################
# Crear rol con permisos de lectura a CSMS (KMS)
resource "huaweicloud_identity_role" "csms_read_policy" {
  name        = "csms-read-policy"
  description = "Allow read access to CSMS secrets for CCE"
  type        = "XA"

  policy = jsonencode({
    Version = "1.1"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "csms:secret:list",
          "csms:secret:get"
        ]
        Resource = ["*"]
      }
    ]
  })
}

# Asignar rol al usuario
resource "huaweicloud_identity_user_role_assignment" "cce_user_csms_role" {
  user_id               = huaweicloud_identity_user.cce_programmatic_user.id
  role_id               = huaweicloud_identity_role.csms_read_policy.id
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

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
          "obs:bucket:ListAllMyBuckets",
          "obs:object:GetObject"
        ]
        Resource = [
          "obs:*:*:bucket:*",
          "obs:*:*:object:*/*"
        ]
      }
    ]
  })
}

resource "huaweicloud_identity_user_role_assignment" "cce_user_obs_role" {
  user_id               = huaweicloud_identity_user.cce_programmatic_user.id
  role_id               = huaweicloud_identity_role.obs_read_policy.id
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}