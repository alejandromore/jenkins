output "elb_public_id" {
  value = huaweicloud_lb_loadbalancer.elb_public.id
}

output "elb_public_ip" {
  value = huaweicloud_vpc_eip.eip_elb.address
}
