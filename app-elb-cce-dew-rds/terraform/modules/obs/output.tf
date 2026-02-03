output "bucket_name" {
  value       = huaweicloud_obs_bucket.this.bucket
  description = "Nombre del bucket OBS."
}

output "bucket_id" {
  value       = huaweicloud_obs_bucket.this.id
  description = "ID del recurso del bucket."
}