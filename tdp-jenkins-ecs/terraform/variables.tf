# ============================================================================
# VARIABLES BASICAS
# ============================================================================
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

# ============================================================================
# VARIABLES GENERALES
# ============================================================================
variable "environment" {
  description = "Environment name (dev, test, prod, local)"
  type        = string
}

variable "enterprise_project_name" {
  description = "Enterprise Project name"
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
}

variable "cloud_init_config" {
  description = "Cloud-init configuration for ECS instances"
  type        = string
}

# ============================================================================
# VARIABLES PARA LA VPC
# ============================================================================

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnets_configuration" {
  description = "List of subnet configurations"
  type = list(object({
    name     = string
    cidr     = string
    dns_list = list(string)
  }))
}

variable "security_group_name" {
  description = "Security group name"
  type        = string
}