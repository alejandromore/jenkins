#######################################
# Agency
#######################################
resource "huaweicloud_identity_agency" "identity_agency" {
  name                  = "cce-workload-agency"
  description           = "Agencia para el CCE"
  delegated_service_name = "op_svc_cce"

  enterprise_project_roles {
    enterprise_project = var.enterprise_project_name
    roles              = ["OBS Administrator", "CSMS FullAccess"]
  }
}


