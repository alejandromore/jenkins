variable "name" {
  description = "Name of the NAT Gateway."
  type        = string
}

variable "description" {
  description = "Description for the NAT Gateway."
  type        = string
  default     = "Huawei Cloud NAT Gateway"
}

variable "vpc_id" {
  description = "VPC ID where the NAT Gateway will be deployed."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID associated with the NAT Gateway."
  type        = string
}

variable "spec" {
  description = "NAT Gateway size (1: Small, 2: Medium, 3: Large)."
  type        = string
  default     = "1"
}

variable "tags" {
  description = "Tags to assign to NAT Gateway."
  type        = map(string)
  default     = {}
}

variable "enterprise_project_id" {
  description = "Enterprise Project iD"
  type        = string
}