data "huaweicloud_enterprise_project" "ep" {
  name = var.enterprise_project_name
}

data "huaweicloud_availability_zones" "myaz" {}

########################################
# Recuperar valores desde DEW (CSMS)
########################################

# Recuperar Cluster ID
data "huaweicloud_csms_secret_version" "cluster_id" {
  secret_name = "infra_base_cluster_id"
}

# Recuperar Subnet ID
data "huaweicloud_csms_secret_version" "subnet_id" {
  secret_name = "infra_base_cce_subnet_id"
}

# Recuperar Security Group ID
data "huaweicloud_csms_secret_version" "security_group_id" {
  secret_name = "infra_base_cce_sg_id"
}

#######################################
# Node Pool
#######################################
data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0] 
  performance_type  = "computingv3" 
  generation        = "c7" 
  cpu_core_count    = 4 
  memory_size       = 8 
} 

resource "huaweicloud_cce_node_pool" "nodepool" {
  cluster_id         = data.huaweicloud_csms_secret_version.cluster_id.secret_text
  name               = "cce-nodepool-public"
  initial_node_count = 1
  subnet_id          = data.huaweicloud_csms_secret_version.subnet_id.secret_text
  flavor_id          = data.huaweicloud_compute_flavors.myflavor.flavors[0].id
  availability_zone  = data.huaweicloud_availability_zones.myaz.names[0]
  os                 = "EulerOS 2.9"
  scall_enable             = true
  min_node_count           = 4
  max_node_count           = 50
  scale_down_cooldown_time = 100
  priority                 = 1
  type                     = "vm"
  root_volume {
    size       = 40
    volumetype = "SAS"
  }
  data_volumes {
    size       = 100
    volumetype = "SAS"
  }
  security_groups    = [data.huaweicloud_csms_secret_version.security_group_id.secret_text]
  key_pair           = var.key_pair_name
  tags = var.tags
}

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
  secret_file = "${path.module}/credentials-cce-programmatic-user.csv"
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
          "csms:secret:get",
          "csms:secretVersion:list",
          "csms:secretVersion:get"
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

resource "huaweicloud_identity_user_role_assignment" "cce_user_obs_role" {
  user_id               = huaweicloud_identity_user.cce_programmatic_user.id
  role_id               = huaweicloud_identity_role.obs_read_policy.id
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

#######################################
# DEW - Secret
#######################################
/*
locals {
  dew_secret_payload = {
    URL      = "wwww.google.com"
    USUARIO  = "alejandro"
    PASSWORD = "P@ssw0rdSecure123!"
    PORT     = "5432"
  }
}
*/

//Utiliza el AK y SK del usuario Terraform, no del usuario IAM para DEW
data "local_file" "cce_credentials" {
  filename = "${path.module}/credentials-cce-programmatic-user.csv"
}

locals {
  # Eliminar BOM si existe
  clean_csv = replace(
    data.local_file.cce_credentials.content,
    "\ufeff",
    ""
  )

  credentials_csv = csvdecode(local.clean_csv)
  credentials     = local.credentials_csv[0]

  HW_USER_ID = local.credentials["User ID"]
  HW_AK      = local.credentials["Access Key ID"]
  HW_SK      = local.credentials["Secret Access Key"]
}

locals {
  secrets_file = yamldecode(file("${path.module}/secrets/secrets-dec.yaml"))
  dew_secret_payload = merge( 
    local.secrets_file.stringData,
    {
      URL      = "wwww.google.com"
      USUARIO  = "alejandro"
      PASSWORD = "P@ssw0rdSecure123!"
      PORT     = "5432"
      HUAWEI_CLOUD_AK = local.HW_AK
      HUAWEI_CLOUD_SK = local.HW_SK
    }
  )
}

output "dew_secret_payload_debug" {
  value = local.dew_secret_payload
}

module "dew_secret" {
  source = "../../../terraform-modules/dew"

  secret_name           = var.dew_secret_name
  secret_description    = var.dew_secret_description
  secret_payload        = local.dew_secret_payload

  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}
