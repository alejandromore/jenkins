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
data "huaweicloud_identity_role" "obs_operate" {
  name = "OBS OperateAccess"
}

resource "huaweicloud_identity_user_role_assignment" "obs_role_attach" {
  user_id = huaweicloud_identity_user.cce_programmatic_user.id
  role_id = data.huaweicloud_identity_role.obs_operate.id
}

data "huaweicloud_identity_role" "csms_secret_user" {
  name = "CSMS Secret User"
}

resource "huaweicloud_identity_user_role_assignment" "csms_role_attach" {
  user_id = huaweicloud_identity_user.cce_programmatic_user.id
  role_id = data.huaweicloud_identity_role.csms_secret_user.id
}

#######################################
# Modificar Agency
#######################################
data "huaweicloud_identity_agency" "cce_cluster_agency" {
  name = "cce_cluster_agency"
}

resource "huaweicloud_identity_agency" "cce_cluster_agency" {
  agency_name       = data.huaweicloud_identity_agency.cce_cluster_agency.name

  enterprise_project_roles {
    enterprise_project = var.enterprise_project_name
    roles              = ["CSMS Secret User"]
  }
}

#######################################
# Instalar Add On
#######################################
resource "huaweicloud_cce_addon" "secrets_manager_dew" {
  cluster_id    = huaweicloud_cce_cluster.cce_cluster_turbo.id
  template_name = "cce-secrets-manager"
  version       = "latest"

  # Valores opcionales del add-on
  # rotation_poll_interval es el periodo de sincronización de secretos, en minutos
  values {
    basic = {
      rotation_poll_interval = "2m"
    }
  }

  # Asegura aplicar después del cluster
  depends_on = [
    huaweicloud_cce_cluster.cce_cluster_turbo
  ]
}