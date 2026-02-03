output "elb_id" {
  value = huaweicloud_elb_loadbalancer.this.id
}
output "elb_vip" {
  value = huaweicloud_elb_loadbalancer.this.vip_address
}
