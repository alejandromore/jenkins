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
  initial_node_count = 2
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
  extend_param = {
    agency_name = huaweicloud_identity_agency.identity_agency.name
  }
  tags = var.tags
}

#######################################
# agency
#######################################
resource "huaweicloud_identity_agency" "identity_agency" {
  name                   = "ecs-obs-dew-agency"
  delegated_service_name = "op_svc_ecs"
  description            = "Agencia para los Nodos del CCE"

  enterprise_project_roles {
    enterprise_project = var.enterprise_project_name
    roles = [
      "OBS Administrator",
      "CSMS FullAccess"
    ]
  }
}

