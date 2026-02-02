variable "name" { type = string, description = "Nombre del ELB." }
variable "subnet_id" { type = string, description = "Subnet del VIP." }
variable "type" { type = string, description = "External o Internal." }
variable "description" { type = string, description = "Descripción." }

variable "bandwidth_name" { type = string, description = "Nombre del BW." }
variable "bandwidth_share_type" { type = string, description = "PER o WHOLE." }
variable "bandwidth_size" { type = number, description = "Tamaño de BW." }
variable "bandwidth_charge_mode" { type = string, description = "Modo de cobro." }
variable "enterprise_project_id" { type = string, description = "Enteprise Project ID." }

variable "tags" { type = map(string), description = "Etiquetas." }
