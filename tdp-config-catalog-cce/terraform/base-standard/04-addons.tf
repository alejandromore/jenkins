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

#######################################
# CCE Addon - Nginx Ingress
#######################################
/*
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

      annotations = {
        "kubernetes.io/elb.id"    = huaweicloud_lb_loadbalancer.elb_public.id
        "kubernetes.io/elb.class" = "union"
      }
    }
    flavor = {
      name = "default"
    }
  }
}
*/

resource "huaweicloud_cce_addon" "nginx_ingress" {

  cluster_id    = huaweicloud_cce_cluster.cce_cluster_standard.id
  template_name = "nginx-ingress"
  version       = "6.0.1"

  values {

    basic = {
      swr_addr        = "swr.la-south-2.myhuaweicloud.com"
      swr_user        = "hwofficial"
      tag             = "v1.14.0_6.0.1"
      rbac_enabled    = "true"
      cluster_version = "v1.33"
    }

    flavor = {
      description = "custom resources"
      name        = "custom-resources"
      size        = "custom"

      resources = jsonencode([
        {
          name        = "cceaddon-nginx-ingress-controller"
          replicas    = 2
          limitsCpu   = "500m"
          requestsCpu = "200m"
          limitsMem   = "512Mi"
          requestsMem = "256Mi"
        },
        {
          name        = "cceaddon-nginx-ingress-default-backend"
          replicas    = 2
          limitsCpu   = "200m"
          requestsCpu = "50m"
          limitsMem   = "128Mi"
          requestsMem = "64Mi"
        }
      ])
    }

    custom = {

      ingressClass = "nginx"

      service = jsonencode({
        type = "LoadBalancer"

        annotations = {
          "kubernetes.io/elb.class"        = "union"
          "kubernetes.io/elb.id"           = "c676fe88-e4e9-4bbf-96a3-5ca367488e36"
          "kubernetes.io/elb.pass-through" = "true"
        }

        loadBalancerIP = ""

        enableHttp  = true
        enableHttps = true

        externalTrafficPolicy = "Local"

        ports = {
          http  = 80
          https = 443
        }

        targetPorts = {
          http  = "http"
          https = "https"
        }
      })

      config = jsonencode({
        allow-backend-server-header     = "false"
        allow-cross-namespace-resources = "true"
        enable-underscores-in-headers   = "false"
        generate-request-id             = "true"
        ignore-invalid-headers          = "true"
        keep-alive-requests             = "100"
        max-worker-connections          = "65536"
        proxy-body-size                 = "20m"
        proxy-connect-timeout           = "10"
        reuse-port                      = "true"
        server-tokens                   = "false"
        ssl-redirect                    = "false"
        strict-validate-path-type       = "false"
        upstream-keepalive-connections  = "320"
        upstream-keepalive-timeout      = "900"
        worker-cpu-affinity             = "auto"
      })

    }

  }

  lifecycle {
    ignore_changes = [values]
  }

}