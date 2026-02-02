output "rds_id" {
  value       = huaweicloud_rds_instance.this.id
  description = "ID of the RDS instance"
}

output "address" {
  value       = huaweicloud_rds_instance.this.private_ips
  description = "Private IP of the RDS instance"
}

