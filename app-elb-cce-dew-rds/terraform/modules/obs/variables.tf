variable "bucket_name" {
  type        = string
  description = "Nombre del bucket OBS."
}

variable "bucket_acl" {
  type        = string
  description = "ACL del bucket: private, public-read o public-read-write."
  default     = "private"
}

variable "storage_class" {
  type        = string
  description = "Clase de almacenamiento: STANDARD, WARM o COLD."
  default     = "STANDARD"
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas del bucket."
  default     = {}
}

variable "enterprise_project_id" {
  type        = string
  description = "Enteprise Project ID"
  default     = null
}
