variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "enterprise_project_id" {
  description = "Enteprise Project ID"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = "Security group managed by Terraform"
}

variable "ingress_rules" {
  description = <<EOT
List of ingress rules.
Each rule supports:
- protocol: tcp/udp/icmp/all
- port: single port (e.g. 22) or range (e.g. 80-8080)
- remote_ip: CIDR block (e.g. 0.0.0.0/0)
EOT
  type = list(object({
    protocol  = string
    port      = string
    remote_ip = string
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    protocol  = string
    port      = string
    remote_ip = string
  }))
  default = []
}