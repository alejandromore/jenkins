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
resource "huaweicloud_identity_group" "workload_group" {
  name        = var.group_name
  description = "IAM group for CCE Workload Identity"
}

resource "huaweicloud_identity_group_role_assignment" "obs_assignment" {
  group_id   = huaweicloud_identity_group.workload_group.id
  role_id    = "8eb36151949e434e857a3446e58cf107" # OBS Administrator
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

resource "huaweicloud_identity_group_role_assignment" "csms_assignment" {
  group_id   = huaweicloud_identity_group.workload_group.id
  role_id    = "0536f2ae1ea5465ca498c7f98ad58510" # CSMS Administrator
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
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
          group = {
            name = huaweicloud_identity_group.workload_group.name
          }
        }
      ]
      remote = [
        {
          type = "UserName"
          any_one_of = [
            "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          ]
        }
      ]
    }
  ])
}