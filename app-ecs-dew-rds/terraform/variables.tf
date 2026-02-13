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

variable "security_group_public_name" {
  description = "Nombre del Grupo de Seguridad Public"
  type        = string
}

variable "security_group_data_name" {
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
  description = "Nombre de la subnet data"
  type        = string
}

variable "vpc_subnet_public_cidr" {
  description = "cidr de la subnet data"
  type        = string
}

variable "vpc_subnet_public_gateway_ip" {
  description = "gateway_ip de la subnet data"
  type        = string
}

variable "vpc_subnet_data_name" {
  description = "Nombre de la subnet data"
  type        = string
}

variable "vpc_subnet_data_cidr" {
  description = "cidr de la subnet data"
  type        = string
}

variable "vpc_subnet_data_gateway_ip" {
  description = "gateway_ip de la subnet data"
  type        = string
}

# ============================================================================
# VARIABLES PARA LA INSTANCIA DE RDS
# ============================================================================

variable "rds_postgres_name" {
  description = "Nombre de la RDS"
  type        = string
}

variable "rds_postgres_password" {
  description = "Password de la RDS"
  type        = string
}

variable "rds_postgres_flavor" {
  description = "Flavor del RDS"
  type        = string
}

variable "rds_postgres_volume_size" {
  description = "Volume Size RDS"
  type        = number
}

# ============================================================================
# VARIABLES PARA LA INSTANCIA DE ECS
# ============================================================================

variable "ecs_public_name" {
  description = "Nombre del ECS"
  type        = string
  default = ""
}

variable "key_pair_name" {
  description = "Nombre del key pair para el ECS"
  type        = string
}

variable "cloud_init_config" {
  description = "Configuración de cloud-init para el ECS"
  type        = string
}

# ============================================================================
# VARIABLES PARA EL DEW
# ============================================================================

variable "dew_secret_name" {
  description = "Nombre del Secret"
  type        = string
  default = ""
}

variable "dew_secret_description" {
  description = "Descripcion del Secret"
  type        = string
  default = ""
}

