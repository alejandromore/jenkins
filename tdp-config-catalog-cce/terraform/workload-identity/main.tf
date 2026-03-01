# Enterprise Project
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
  group_id = huaweicloud_identity_group.obs_group.id
  role_id  = huaweicloud_identity_role.obs_read_policy.id
  #project_id = var.project_id
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  lifecycle {
    create_before_destroy = true
  }
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
  group_id = huaweicloud_identity_group.dew_group.id
  role_id  = huaweicloud_identity_role.dew_read_policy.id
  #project_id = var.project_id
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  lifecycle {
    create_before_destroy = true
  }
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