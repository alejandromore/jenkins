variable "environment" {
  description = "Nombre del ambiente (noprod, prod)"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the ECS"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "Nombre de la region"
  type        = string
  default = ""
}

variable "access_key" {
  description = "Nombre del Grupo de Securidad"
  type        = string
  default = ""
}

variable "secret_key" {
  description = "Nombre del Grupo de Securidad"
  type        = string
  default = ""
}

variable "enterprise_project_name" {
  description = "Nombre del proyecto empresarial"
  type        = string
}

variable "security_group_public" {
  description = "Nombre del Grupo de Seguridad Public"
  type        = string
}


variable "vpc_name" {
  description = "Nombre de la vpc"
  type        = string
}

variable "vpc_cidr" {
  description = "cidr de la vpc"
  type        = string
}

variable "dns_list" {
  description = "dns_list"
  type        = list(string)
}

# ============================================================================
# VARIABLES PARA LA INSTANCIA DE VPC Subnet
# ============================================================================

variable "vpc_subnet_public_name" {
  description = "Nombre de la subnet public"
  type        = string
}

variable "vpc_subnet_public_cidr" {
  description = "cidr de la subnet public"
  type        = string
}

variable "vpc_subnet_public_gateway_ip" {
  description = "gateway_ip de la subnet public"
  type        = string
}

# ============================================================================
# VARIABLES PARA EL FUNCTION GRAPH
# ============================================================================

variable "fgs_name" {
  description = "Nombre de la función FunctionGraph"
  type        = string
  default     = "java-event-function"
}

variable "fgs_runtime" {
  description = "Runtime de la función"
  type        = string
  default     = "Java21"
}

variable "fgs_memory_size" {
  description = "Tamaño de memoria en MB"
  type        = number
  default     = 512
}

variable "fgs_timeout"{
  description = "Timeout de la funcion"
  type        = number
  default     = 30
}

variable "fgs_handler" {
  description = "Handler de la función"
  type        = string
  default     = "com.example.Function.handler"
}

variable "fgs_code_type" {
  description = "Tipo de Codigo"
  type        = string
  default     = "obs"
}

variable "app_file" {
  description = "Nombre del archivo de la app"
  type        = string
  default     = ""
}

# ============================================================================
# VARIABLES PARA EL OBS
# ============================================================================

variable "obs_bucket_name" {
  description = "Nombre del bucket OBS"
  type        = string
  default     = ""
}
variable "obs_bucket_acl" {
  description = "Nombre del bucket OBS"
  type        = string
  default     = "private"
}

variable "obs_storage_class" {
  description = "Class del bucket OBS"
  type        = string
  default     = "STANDARD"
}

variable "obs_frontend_bucket_name" {
  description = "Nombre del bucket OBS"
  type        = string
  default     = ""
}
variable "obs_frontend_bucket_acl" {
  description = "Nombre del bucket OBS"
  type        = string
  default     = "private"
}

variable "obs_frontend_storage_class" {
  description = "Class del bucket OBS"
  type        = string
  default     = "STANDARD"
}
