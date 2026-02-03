output "secret_id" {
  description = "ID of the DEW secret"
  value       = huaweicloud_csms_secret.this.id
}

output "secret_name" {
  value = huaweicloud_csms_secret.this.name
}