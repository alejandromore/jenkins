resource "huaweicloud_identity_agency" "cce_node_agency" {
  name                   = "cce_node_agency"
  description            = "Agency para que los nodos de CCE accedan a OBS y DEW"
  delegated_service_name = "op_svc_ecs" 

  project_role {
    project = var.region
    roles = [
      "OBS OperateAccess",  # Para descargar archivos
      "KMS Administrator",  # Para usar llaves de DEW
      "CSMS ReadOnlyAccess" # Específico para leer secretos de DEW/Cloud Secret Management Service
    ]
  }
}