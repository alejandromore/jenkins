resource "huaweicloud_identity_agency" "obs_workload_agency" {
  name                   = "obs-workload-agency"
  delegated_service_name = "op_svc_ecs"

  project_role {
    project = var.region
    roles = [
      "OBS OperateAccess"
    ]
  }
}