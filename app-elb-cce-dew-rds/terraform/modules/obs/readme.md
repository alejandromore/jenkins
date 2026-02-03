# Módulo OBS (Huawei Cloud)

## Descripción
Crea un bucket de OBS con opciones de ACL, versionado, cifrado SSE-KMS, logging, lifecycle y CORS. Opcionalmente aplica una política de bucket.

## Entradas principales
- **region:** Región del proveedor (ej. la-south-2 para Lima/Perú cercano).
- **project_id, access_key, secret_key:** Credenciales/tenant.
- **bucket_name:** Nombre único del bucket.
- **bucket_acl:** private | public-read | public-read-write.
- **storage_class:** STANDARD | WARM | COLD.
- **enable_versioning:** true/false.
- **kms_key_id:** ID de llave KMS para SSE-KMS (opcional).
- **logging_target_bucket / logging_target_prefix:** Logging de acceso (opcional).
- **lifecycle_rules:** Reglas de ciclo de vida (transiciones y expiraciones).
- **cors_rules:** Reglas CORS (orígenes, métodos, headers).
- **bucket_policy_json:** Política JSON opcional.
- **tags:** Mapa de etiquetas.

## Ejemplo de uso

```hcl
module "obs" {
  source = "./modules/obs"

  region     = "la-south-2"
  project_id = var.project_id
  access_key = var.access_key
  secret_key = var.secret_key

  bucket_name  = "mi-bucket-prod-latam"
  bucket_acl   = "private"
  storage_class = "STANDARD"

  enable_versioning = true
  kms_key_id        = "your-kms-key-id"

  logging_target_bucket = "mi-bucket-logs"
  logging_target_prefix = "obs/"

  lifecycle_rules = [
    {
      id                = "warm-30d"
      enabled           = true
      filter_prefix     = "data/"
      transitions       = [{ days = 30, storage_class = "WARM" }]
      expiration_days   = 365
    },
    {
      id                                 = "noncurrent-cleanup"
      enabled                            = true
      noncurrent_version_expiration_days = 90
    }
  ]

  cors_rules = [
    {
      allowed_origin  = ["https://miapp.com"]
      allowed_method  = ["GET", "PUT"]
      allowed_header  = ["Authorization", "Content-Type"]
      expose_header   = ["ETag"]
      max_age_seconds = 600
    }
  ]

  bucket_policy_json = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowList"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["obs:ListBucket"]
        Resource  = ["arn:huaweicloud:obs:::mi-bucket-prod-latam"]
      }
    ]
  })

  tags = {
    env  = "prod"
    team = "data-platform"
  }
}
