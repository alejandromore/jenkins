variable "dws_name" {
  type        = string
  description = "Name of the DWS cluster"
}

variable "node_type" {
  type        = string
  description = "Type of the compute node for DWS"
  default     = "dwsx3.4U16G.4DPU"
}

variable "number_of_nodes" {
  type        = number
  description = "Number of data nodes in the DWS cluster"
  default     = 3
}

variable "number_of_cn" {
  type        = number
  description = "Number of coordinator nodes"
  default     = 3
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone where the DWS cluster will be deployed"
}

variable "db_username" {
  type        = string
  description = "Admin username for DWS cluster"
  default     = "dbadmin"
}

variable "db_password" {
  type        = string
  description = "Admin password for DWS cluster"
  sensitive   = true
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the DWS cluster will be deployed"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet for DWS networking"
}

variable "security_group_id" {
  type        = string
  description = "ID of the security group applied to DWS"
}

variable "volume_type" {
  type        = string
  description = "Volume type for the DWS storage"
  default     = "SSD"
}

variable "volume_capacity" {
  type        = number
  description = "Storage capacity in GB"
  default     = 300
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags"
  default     = {}
}

variable "enterprise_project_id" {
  description = "Enterprise Project iD"
  type        = string
}