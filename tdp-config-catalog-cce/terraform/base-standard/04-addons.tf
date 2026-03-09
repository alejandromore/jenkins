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
      replica_count = "2"

      annotations = jsonencode({
        "kubernetes.io/elb.id" = huaweicloud_elb_loadbalancer.elb_public.id
      })
    }

    flavor = {
      name = "custom-resources"
    }
  }
}

#######################################
# CCE Addon - Nginx Ingress
#######################################
resource "huaweicloud_cce_addon" "nginx_ingress" {
  cluster_id    = huaweicloud_cce_cluster.cce_cluster_standard.id
  template_name = "nginx-ingress"
  version       = "6.0.1"
  values {
    basic = {
      cluster_version = "v1.33"
      rbac_enabled    = "true"
      swr_addr        = "swr.la-south-2.myhuaweicloud.com"
      swr_user        = "hwofficial"
    }
    custom = {
      replica_count = "2"
    }
    flavor = {
      name = "default"
    }
  }
}