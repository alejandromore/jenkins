output "subnet_id" {
  description = "The ID of the subnet"
  value       = huaweicloud_vpc_subnet.this.id
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = huaweicloud_vpc_subnet.this.name
}

output "subnet_cidr" {
  description = "The CIDR block of the subnet"
  value       = huaweicloud_vpc_subnet.this.cidr
}

output "ipv4_subnet_id" {
  description = "IPv4 Subnet ID"
  value       = huaweicloud_vpc_subnet.this.ipv4_subnet_id
}
