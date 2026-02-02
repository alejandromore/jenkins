variable "vpc_id" {
  description = "ID of the VPC where the subnet will be created"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "cidr" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "gateway_ip" {
  description = "Gateway IP for the subnet"
  type        = string
}

variable "dns_list" {
  description = "dns_list"
  type        = list(string)
}

variable "tags" {
  description = "Tags to assign to the ECS"
  type        = map(string)
  default     = {}
}

variable "availability_zone" {
  description = "Availability Zone for the subnet"
  type        = string
}

variable "dhcp_enable" {
  description = "Enable or disable DHCP"
  type        = bool
  default     = true
}

variable "description" {
  description = "Description for the subnet"
  type        = string
  default     = ""
}