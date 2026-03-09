#resource "huaweicloud_cce_cluster" "mi_cluster_turbo" {
#  id    = "17b294eb-1bbe-11f1-8f6f-0255ac10023b"
#}

#resource "huaweicloud_identity_agency" "ecs-obs-agency"{
#}


#resource "huaweicloud_cce_addon" "secrets_manager_dew" {
#  cluster_id    = "a63e1ee2-0e5f-11f1-9307-0255ac100249"
#  template_name = "dew-provider"
#  version       = "1.1.95"
#}


resource "huaweicloud_cce_addon" "ingress_controller" {
  cluster_id    = "17b294eb-1bbe-11f1-8f6f-0255ac10023b"
  template_name = "nginx-ingress"
  version       = "6.0.1"
}


/*
resource "huaweicloud_cce_addon" "nginx_ingress" {
  cluster_id    = "17b294eb-1bbe-11f1-8f6f-0255ac10023b"
  template_name = "nginx-ingress"
}
*/

/*
data "huaweicloud_enterprise_project" "ep" {
  name = "enterprise-app"
}

resource "huaweicloud_identity_group_role_assignment" "obs_assignment" {
  group_id              = "d8ccd1d818004d2cb4de25f72134ebcb"
  role_id               = "ROLE_ID_OBS"
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

resource "huaweicloud_identity_group_role_assignment" "csms_assignment" {
  group_id              = "d8ccd1d818004d2cb4de25f72134ebcb"
  role_id               = "ROLE_ID_CSMS"
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

*/