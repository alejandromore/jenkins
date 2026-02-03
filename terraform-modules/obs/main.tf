# Bucket OBS
resource "huaweicloud_obs_bucket" "this" {
  bucket                = var.bucket_name
  acl                   = var.bucket_acl # private | public-read | public-read-write
  storage_class         = var.storage_class # STANDARD | WARM | COLD
  enterprise_project_id = var.enterprise_project_id

  tags = var.tags
}
