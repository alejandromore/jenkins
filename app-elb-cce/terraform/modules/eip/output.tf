output "address" {
  value = huaweicloud_vpc_eip.this.address
}

output "eip_id" {
  value = huaweicloud_vpc_eip.this.id
  description = "ID of the Elastic IP"
}