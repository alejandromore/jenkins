#resource "huaweicloud_cce_cluster" "mi_cluster_turbo" {
#}

#resource "huaweicloud_identity_agency" "ecs-obs-agency"{
#}


resource "huaweicloud_cce_addon" "secrets_manager_dew" {
  cluster_id    = "a63e1ee2-0e5f-11f1-9307-0255ac100249"
  template_name = "dew-provider"
  version       = "1.1.95"
}