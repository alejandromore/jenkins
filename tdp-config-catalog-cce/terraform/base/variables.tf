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

variable "dns_list" {
  description = "DNS List"
  type = list(string)
}

# ============================================================================
# VARIABLES PARA LA VPC Subnet
# ============================================================================
variable "vpc_subnet_cce_name" {
  description = "Name of the VPC Subnet CCE"
  type        = string
}

variable "vpc_subnet_cce_cidr" {
  description = "CIDR block for the VPC Subnet CCE"
  type        = string
}
variable "vpc_subnet_cce_gateway_ip" {
  description = "Gateway IP for the VPC Subnet CCE"
  type        = string
}

variable "vpc_subnet_cce_eni_name" {
  description = "Name of the VPC Subnet CCE ENI"
  type        = string
}

variable "vpc_subnet_cce_eni_cidr" {
  description = "CIDR block for the VPC Subnet CCE ENI"
  type        = string
}
variable "vpc_subnet_cce_eni_gateway_ip" {
  description = "Gateway IP for the VPC Subnet CCE ENI"
  type        = string
}

# ============================================================================
# SECURITY GROUPS
# ============================================================================
variable "security_group_elb" {
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
# VARIABLES PARA EL ELB - EIP
# ============================================================================
variable "bandwidth_name" {
  type = string
}

variable "bandwidth_size" {
  type = number
}

variable "eip_elb_name" {
  type = string
}

variable "eip_ng_name" {
  type = string
}

variable "eip_cce_name" {
  type = string
}

variable "eip_publicip_configuration" {
  type = list(object({
    type       = string
    ip_version = string
  }))
}

variable "eip_bandwidth_configuration" {
  type = list(object({
    share_type = string
    name       = string
    size       = number
  }))
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

variable "key_alias" {
  description = "Alias del KMS Key para cifrar secretos"
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