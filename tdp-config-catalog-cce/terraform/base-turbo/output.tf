output "elb_public_id" {
  #value = huaweicloud_lb_loadbalancer.elb_public.id
  value = huaweicloud_elb_loadbalancer.elb_public.id
}

output "elb_public_ip" {
  value = huaweicloud_vpc_eip.eip_elb.address
}

output "kubeconfig" {
  value     = huaweicloud_cce_cluster.cce_cluster_turbo.kube_config_raw
  sensitive = true
}