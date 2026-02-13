variable "environment" {
  description = "Nombre del ambiente (noprod, prod)"
  type        = string
}

variable "project_id" {
  description = "Project ID"
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
# SECURITY GROUPS
# ============================================================================
variable "security_group_public" {
  description = "Nombre del Grupo de Seguridad Public"
  type        = string
}

variable "security_group_cce" {
  description = "Nombre del Grupo de Seguridad CCE Nodes"
  type        = string
}

variable "security_group_cce_eni" {
  description = "Nombre del Grupo de Seguridad CCE ENI"
  type        = string
}

# ============================================================================
# VARIABLES PARA LA INSTANCIA DE VPC Subnet
# ============================================================================

variable "vpc_subnet_public_name" {
  description = "Nombre de la subnet publica"
  type        = string
}

variable "vpc_subnet_public_cidr" {
  description = "cidr de la subnet publica"
  type        = string
}

variable "vpc_subnet_public_gateway_ip" {
  description = "gateway_ip de la subnet publica"
  type        = string
}

variable "vpc_subnet_cce_eni_name" {
  description = "Nombre de la subnet CCE ENI"
  type        = string
  default = ""
}

variable "vpc_subnet_cce_eni_cidr" {
  description = "cidr de la subnet CCE ENI"
  type        = string
  default = ""
}

variable "vpc_subnet_cce_eni_gateway_ip" {
  description = "gateway_ip de la subnet CCE ENI"
  type        = string
  default = ""
}

variable "vpc_subnet_cce_name" {
  description = "Nombre de la subnet CCE"
  type        = string
  default = ""
}

variable "vpc_subnet_cce_cidr" {
  description = "cidr de la subnet CCE"
  type        = string
  default = ""
}

variable "vpc_subnet_cce_gateway_ip" {
  description = "gateway_ip de la subnet CCE"
  type        = string
  default = ""
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

# ============================================================================
# VARIABLES PARA EL CCE
# ============================================================================
variable "eip_cce_name" {
  description = "Nombre de la IP del CCE"
  type        = string
  default = ""
}

variable "cce_cluster_name" {
  type        = string
  description = "Nombre del clúster CCE."
}

variable "cce_cluster_type" {
  type        = string
  description = "Tipo del clúster CCE (VirtualMachine o BareMetal)."
}

variable "cce_cluster_flavor" {
  type        = string
  description = "Flavor del clúster CCE."
}

variable "cce_k8s_version" {
  type        = string
  description = "Versión de Kubernetes del clúster CCE."
}

variable "cce_network_type" {
  type        = string
  description = "Tipo de red del contenedor (overlay_l2, vpc-router, eni)."
}

variable "cce_network_cidr" {
  type        = string
  description = "CIDR de la red del contenedor (overlay_l2, vpc-router, eni)."
}

variable "cce_authentication_mode" {
  type        = string
  description = "Método de autenticación del clúster (x509 o rbac)."
}

variable "cce_charging_mode" {
  type        = string
  description = "Modo de facturación del clúster (postPaid o prePaid)."
}

variable "cce_node_password" {
  type        = string
  description = "Password del nodo del CCE."
}

variable "key_pair_name" {
  description = "Nombre del Key Pair para los nodos"
  type        = string
}

# ============================================================================
# VARIABLES NAT GATEWAY
# ============================================================================
variable "ng_name" {
  description = "Name of the NAT Gateway."
  type        = string
}

variable "ng_description" {
  description = "Description for the NAT Gateway."
  type        = string
  default     = "Huawei Cloud NAT Gateway"
}

variable "ng_spec" {
  description = "NAT Gateway size (1: Small, 2: Medium, 3: Large)."
  type        = string
  default     = "1"
}

# ============================================================================
# VARIABLES SFS
# ============================================================================
variable "sfs_name" {
  type        = string
  description = "Name for the SFS Turbo"
  default     = ""
}

variable "sfs_size_gb" {
  type        = number
  description = "Capacity of SFS Turbo in GiB"
  default     = 500
}