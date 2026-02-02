variable "ecs_name" {
  description = "Name of the ECS instance"
  type        = string
}

variable "flavor_id" {
  description = "ECS flavor (hardware configuration)"
  type        = string
}

variable "image_id" {
  description = "Image ID for the ECS (e.g. Ubuntu, CentOS)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ECS network"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the ECS will be placed"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the ECS"
  type        = string
}

variable "keypair_name" {
  description = "Name of the keypair to log into the ECS"
  type        = string
}

variable "ecs_password" {
  description = "Password into the ECS"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = string
}

variable "root_volume_type" {
  description = "Type of root disk"
  type        = string
  default     = "SAS"
}

variable "root_volume_size" {
  description = "Size of root disk (GB)"
  type        = number
  default     = 40
}

variable "tags" {
  description = "Tags to assign to the ECS"
  type        = map(string)
  default     = {}
}

variable "enterprise_project_id" {
  description = "Enterprise Project iD"
  type        = string
}

variable "agency_name" {
  description = "Name of the Agency"
  type        = string
  default     = null
}