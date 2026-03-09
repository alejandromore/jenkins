#######################################
# CCE Addons
#######################################
resource "huaweicloud_cce_addon" "secrets_manager_dew" {
  cluster_id    = huaweicloud_cce_cluster.cce_cluster_turbo.id
  template_name = "dew-provider"
  version       = "1.1.95"

  depends_on = [huaweicloud_cce_cluster.cce_cluster_turbo]

  values {

    basic = {
      dewEndpoint                = "https://kms.la-south-2.myhuaweicloud.com"
      dew_provider_image_version = "1.1.95"
      region                     = var.region
      swr_addr                   = "swr.la-south-2.myhuaweicloud.com"
      swr_user                   = "hwofficial"
      rbac_enabled               = "true"
      cluster_version            = var.cce_k8s_version
    }

    flavor = {
      name = "custom-resources"
    }
  }
}
