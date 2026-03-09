#######################################
# CCE Addon - DEW Provider
#######################################
resource "huaweicloud_cce_addon" "secrets_manager_dew" {
  cluster_id    = huaweicloud_cce_cluster.cce_cluster_standard.id
  template_name = "dew-provider"
  version       = "1.1.95"

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

    custom = {
      agency_name            = ""
      rotation_poll_interval = "2m"
      aksk_secret_name       = "paas.elb"
      driver_writes_secrets  = "false"
      get_version_burst      = "5"
      get_version_qps        = "5"
      project_id             = data.huaweicloud_enterprise_project.ep.id
    }

    flavor = {
      name = "custom-resources"
    }
  }
}
/*
#######################################
# CCE Addon - Nginx Ingress
#######################################
resource "huaweicloud_cce_addon" "nginx_ingress" {
  cluster_id    = huaweicloud_cce_cluster.cce_cluster_turbo.id
  template_name = "nginx-ingress"
  version       = "2.4.5"
  values {
    basic = {
      image_version   = "v1.9.3"
      cluster_version = var.cce_k8s_version
      swr_addr        = "swr.la-south-2.myhuaweicloud.com"
      swr_user        = "hwofficial"
      rbac_enabled    = "true"
    }
    custom = {
      replica_count = "2"
    }
    flavor = {
      name = "default"
    }
  }
}
*/