output "cce_name" {
  value = var.cce_cluster_name
}

output "cce_public_ip" {
  value = module.eip_cce_cluster.address
}

output "cluster_id" {
  value = module.cce_cluster.cluster_id
}

output "elb_public_id" {
  value = huaweicloud_lb_loadbalancer.elb_public.id
}

output "elb_public_ip" {
  value = module.eip_elb_public.address
}

output "sfs_jenkins_id" {
  value       = huaweicloud_sfs_turbo.jenkins.id
}