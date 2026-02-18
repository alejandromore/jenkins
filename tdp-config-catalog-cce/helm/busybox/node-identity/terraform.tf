resource "huaweicloud_identity_agency" "obs_workload_agency" {
  name                   = "ecs-obs-dew-agency"
  delegated_service_name = "op_svc_ecs"

  enterprise_project_roles {
    enterprise_project = var.enterprise_project_name
    roles = [
      "OBS Administrator",
      "CSMS FullAccess"
    ]
  }
}

resource "huaweicloud_cce_node_pool" "nodepool" {
  extend_param = {
    agency_name = huaweicloud_identity_agency.obs_workload_agency.name
  }
}